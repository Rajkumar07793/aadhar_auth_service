import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle = true,
    this.titleWidget,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    // var textTheme = Theme.of(context).textTheme;
    // var themeMode = MediaQuery.of(context).platformBrightness;
    // bool isDarkMode = themeMode == Brightness.dark;
    // print(themeMode);
    return AppBar(
      // flexibleSpace: Container(
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage(IconConstants.icBackSpaceData),
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.transparent,
      leading: leading,
      // leading: leading ??
      //     GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: SizedBox(
      //         height: MediaQuery.of(context).size.height * 2 / 100,
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 10),
      //           child: Image.asset(
      //             IconConstants.icBackSpaceData,
      //             scale: 2,
      //           ),
      //         ),
      //       ),
      //     ),
      elevation: 0,
      // backgroundColor: Colors.transparent,
      //backgroundColor: AppColor.whiteColor,

      // backgroundColor: headerColor,
      // leading: const BackButton(
      //   color: Colors.white,
      // ),
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: centerTitle,
      bottom: bottom,

      title:
          titleWidget ??
          (title != null
              ? Text(
                  title ?? "",
                  style: TextStyle(color: Color(0xff1C1C1C), fontSize: 18),
                  // style: const TextStyle(color: Colors.white),
                  // style: textTheme.titleMedium,
                  // style: TextStyle(
                  //     color: AppColor.blackColor,
                  //     fontSize: 18,
                  //     fontFamily: AppFont.fontFamily,
                  //     fontWeight: FontWeight.w500),
                )
              : null),
      // : Image.asset(
      //     IconConstants.icBroadLinkLogo,
      //     height: MediaQuery.of(context).size.height * 38 / 100,
      //     width: MediaQuery.of(context).size.width * 38 / 100,
      //   )),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size(200, 50);
}
