import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/models/tabungan_model.dart';
import 'package:mobile_info/module/auth/lock_screen_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/module/repository/home_repository.dart';
import 'package:mobile_info/module/repository/rekening_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/images_path.dart';

import '../../network/network.dart';
import '../../utils/pro_shimmer.dart';

class HomeNotifier extends ChangeNotifier {
  final BuildContext context;

  HomeNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    users = await Pref().getUsers();
    print("BPR ID HOME: ${users!.bprId}");
    print("BPR LOGO HOME: ${users!.bprLogo}");
    print("perbarindo HOME: ${users!.perbarindo}");

    /// 2. sekarang BARU aman
    getHome();
    loadTabungan();
    initializeTimer();
    getRateProduk();

    notifyListeners();
  }

  List<Map<String, dynamic>> listtabungan = [];
  List<Map<String, dynamic>> listdeposito = [];
  Future getRateProduk() async {
    listtabungan.clear();
    listdeposito.clear();
    notifyListeners();
    AuthRepository.post(NetworkURL.rateproduk(), {"bpr_id": users!.bprId}).then((value) {
      for (Map<String, dynamic> i in value['data']['data']['tabungan']) {
        listtabungan.add(i);
      }
      for (Map<String, dynamic> i in value['data']['data']['deposito']) {
        listdeposito.add(i);
      }
      notifyListeners();
    });
  }

  Timer? _rootTimer;

  void initializeTimer() {
    if (_rootTimer != null) _rootTimer!.cancel();
    const time = const Duration(minutes: 5);
    print(time);
    _rootTimer = Timer(time, () {
      logOutUser();
    });
  }

  String get logoByBprId {
    final bprId = users?.bprId;

    switch (bprId) {
      case "600931":
        return ImageAssets.dpdJatim; // dpd_jatim.png
      case "609999":
        return ImageAssets.dpdJateng; // dpd_jateng.png
      default:
        return ImageAssets.logomedfo; // medfo_logo.jpeg
    }
  }

  void logOutUser() async {
    // Log out the user if they're logged in, then cancel the timer.
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LockScreenPage()), (route) => false);
    _rootTimer?.cancel();
  }

  void handleUserInteraction([_]) {
    if (_rootTimer != null && !_rootTimer!.isActive) {
      // This means the user has been logged out
      return;
    }
    _rootTimer?.cancel();

    initializeTimer();
  }

  int page = 0;

  void toggleSaldo() {
    hideSaldo = !hideSaldo;
    notifyListeners();
  }

  List<TabunganModel> listTabungan = [];
  bool loadingTabungan = false;

  Future loadTabungan() async {
    loadingTabungan = true;
    notifyListeners();

    try {
      listTabungan = await RekeningRepository.getTabungan(
        token: token,
        endpoint: NetworkURL.inquiryMasterData(),
        userlogin: "admin",
        // bprId: users!.bprId,
        bprId: users!.bprId,
        nocif: users!.noCif,
      );
    } catch (e) {
      debugPrint("ERROR TABUNGAN: $e");
    }

    loadingTabungan = false;
    notifyListeners();
  }

  var isLoading = true;
  List<BannersModel> list = [];
  List<BannersModel> listBanner = [];
  List<BannersModel> listDialog = [];
  List<ProdukModel> listProduk = [];
  Future getHome() async {
    isLoading = true;
    list.clear();
    listProduk.clear();
    notifyListeners();
    HomeRepository.homeData(token, NetworkURL.homeData(), users!.id, users!.bprId).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['banner']) {
          list.add(BannersModel.fromJson(i));
        }
        for (Map<String, dynamic> i in value['produk']) {
          listProduk.add(ProdukModel.fromJson(i));
        }
        listDialog = list.where((e) => e.tipe == "DIALOG" && e.urutan != null).toList()..sort((a, b) => a.urutan!.compareTo(b.urutan!));

        listBanner = list.where((e) => e.tipe != "DIALOG" && e.urutan != null).toList()..sort((a, b) => a.urutan!.compareTo(b.urutan!));
        if (listDialog.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => ProShimmer(height: 300, width: 400, radius: 8),
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  height: 300,
                  width: 400,
                  imageUrl: "https://infoservices.medtrans.id/webServices/image-proxy.php?url=$upload/${listDialog[0].banners}",
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          );
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  var isLoadingSaldo = false;
  var hideSaldo = true;
  int saldo = 0;
}
