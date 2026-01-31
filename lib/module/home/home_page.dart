import 'package:flutter/material.dart';
import 'package:mobile_info/module/home/home_notifier.dart';
import 'package:mobile_info/module/mutasi/mutasi_tabungan_page.dart';

import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:mobile_info/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../network/network.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(context: context),
      child: Consumer<HomeNotifier>(
        builder: (context, value, child) => Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: value.handleUserInteraction,
          onPointerMove: value.handleUserInteraction,
          onPointerUp: value.handleUserInteraction,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 250, 250),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      value.users!.bprId == "609999"
                          ? Image.asset(ImageAssets.logomedfo, height: 70, fit: BoxFit.contain)
                          : Container(
                              height: 80,
                              width: 100,
                              child: Column(
                                children: [
                                  Image.asset(ImageAssets.perbarindo, height: 60, fit: BoxFit.contain),

                                  Text(
                                    "${value.users!.perbarindo}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titlePerbarindo),
                                  ),
                                ],
                              ),
                            ),
                      Spacer(),
                      Image.network("https://infoservices.medtrans.id/webServices/image-proxy.php?url=${value.users!.bprLogo}", height: 70),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => value.getHome(),
                    color: const Color.fromARGB(255, 0, 95, 0),
                    child: ListView(
                      children: [
                        value.isLoading
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProShimmer(height: 10, width: 200),
                                    SizedBox(height: 4),
                                    ProShimmer(height: 10, width: 120),
                                    SizedBox(height: 4),
                                    ProShimmer(height: 10, width: 100),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 110,
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 10,
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [colorTop, colorBottom],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -270,
                                            left: -100,
                                            child: Container(
                                              height: 300,
                                              width: 300,
                                              decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 140, 1), shape: BoxShape.circle),
                                            ),
                                          ),

                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Spacer(),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              "${value.users!.nama}",
                                                              textAlign: TextAlign.end,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text("No CIF: ${value.users!.noCif}", style: TextStyle(fontSize: 12)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Container(
                                    margin: EdgeInsets.all(16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color.fromARGB(255, 137, 206, 252),
                                      boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.grey[300] ?? Colors.transparent, blurRadius: 5)],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: value.page == 0 ? const Color.fromARGB(255, 0, 95, 0) : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 0 ? const Color.fromARGB(255, 0, 95, 0) : Colors.grey.shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Tabungan",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 12, color: value.page == 0 ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        _produkTabungan(value, context),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _produkTabungan(HomeNotifier value, BuildContext context) {
  if (value.loadingTabungan) {
    return const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator());
  }

  return Column(
    children: value.listTabungan.map((tabungan) {
      return accountProductCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MutasiTabunganPage(noRekening: tabungan.noAcc, namaProduk: tabungan.namaProduk),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.credit_card, color: Color.fromARGB(255, 0, 95, 0)),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tabungan.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(tabungan.noAcc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text("Rp ${FormatCurrency.oCcy.format(tabungan.saldo)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList(),
  );
}

Widget accountProductCard({
  required VoidCallback onTap,
  required Widget leading, // icon / image
  required Widget content, // text area (beda tiap card)
  bool showArrow = true,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 5, color: Colors.grey[300] ?? Colors.transparent)],
      ),
      child: Row(
        children: [
          /// LEFT ICON / IMAGE
          leading,

          const SizedBox(width: 12),

          /// MIDDLE CONTENT
          Expanded(child: content),

          /// RIGHT ARROW
          if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
  );
}

void showMobileDialog({required BuildContext context, required Widget child}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(), // ✅ TAP LUAR TUTUP
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // ❗ cegah close saat tap konten
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

enum DialogMode { video, image, text }

Widget mobileDialogWrapper(BuildContext context, {required Widget child, DialogMode mode = DialogMode.text, double aspectRatio = 16 / 9}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final width = screenWidth > 600 ? 400.0 : screenWidth * 0.95;
  final video_width = screenWidth > 900 ? 800.0 : screenWidth * 0.95;

  double? height;
  if (mode == DialogMode.video) {
    height = video_width / aspectRatio;
  } else if (mode == DialogMode.image) {
    height = screenHeight * 0.7;
  }

  return Container(
    width: 380,
    height: height,
    constraints: const BoxConstraints(minHeight: 80),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: mode == DialogMode.text ? Colors.white : Colors.transparent),
    child: child,
  );
}
