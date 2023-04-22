import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';

import '../contact/contact_screen.dart';
import '../product/product_i/product_items.dart';
import '../product/product_names.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late BannerAd staticAd;
  late BannerAd inlineAd;
  static const AdRequest request = AdRequest();
  TextEditingController textEditingController = TextEditingController();

  bool staticAdLoaded = false;
  bool inLineAdLoaded = false;

  void loadStaticBannerAd() {
    staticAd = BannerAd(
        adUnitId: Platform.isAndroid ? androidValue : iosValue,
        size: AdSize.banner,
        request: request,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            staticAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }));
    staticAd.load();
  }

  String get iosValue => 'ca-app-pub-3607831848054936/7607643964';

  String get androidValue => 'ca-app-pub-3607831848054936/3632454529';

  void loadInLineBannerAd() {
    inlineAd = BannerAd(
        adUnitId: Platform.isAndroid ? androidValue : iosValue,
        size: AdSize.banner,
        request: request,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            inLineAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }));
    inlineAd.load();
  }

  @override
  void initState() {
    loadInLineBannerAd();
    loadStaticBannerAd();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double normalHeiht = 460;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [contactButton(context)],
        title: Center(
            child: Text(
          title,
          style: italicFontStyle().copyWith(fontSize: 20.0),
        )),
        flexibleSpace: _appBarDecoration(),
        shape: _appBarBorder(),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 10),
            kionskNameTextField(),
            SizedBox(
              height: normalHeiht,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: itemListViewBuilder(),
              ),
            ),
            _readyButton(context),
            adContainer()
          ]),
        ),
      ),
    );
  }

  adContainer() {
    return Container(
      width: staticAd.size.width.toDouble(),
      height: staticAd.size.height.toDouble(),
      alignment: Alignment.bottomCenter,
      child: AdWidget(ad: staticAd),
    );
  }

  ListView itemListViewBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: productItems.length,
        itemBuilder: (context, index) {
          final productItem = productItems[index];
          return Card(
            shape: _cardBorder(),
            color: _cardItemColor(productItem),
            child: ListTile(
              title: Text(
                productItem.name,
                style: italicFontStyle(),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _removeCountButton(productItem),
                  const SizedBox(
                    width: 15,
                  ),
                  _countText(productItem),
                  _addCountButton(productItem),
                ],
              ),
            ),
          );
        });
  }

  TextField kionskNameTextField() {
    return TextField(
        maxLines: maxLines,
        maxLength: maxLength,
        controller: textEditingController,
        decoration: InputDecoration(border: myinputborder(), labelText: labelText));
  }

  IconButton contactButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) => const ContactWithMe())));
        },
        icon: const Icon(Icons.contacts_outlined));
  }

  int get maxLength => 25;

  int get maxLines => 1;

  String get labelText => 'Buraya kiosk adını yazın';

  OutlineInputBorder myinputborder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(35)),
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 3,
      ),
    );
  }

  String get title => 'Quick Note';

  RoundedRectangleBorder _appBarBorder() => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48.0)));

  Container _appBarDecoration() {
    return Container(
        decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(48.0)), gradient: _colorBluePurple()));
  }

  RoundedRectangleBorder _cardBorder() {
    return const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)));
  }

  Color? _cardItemColor(ProductItem productItem) => productItem.count > 0 ? Colors.blue[100] : Colors.white;

  ElevatedButton _readyButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          final res = productItems.where((element) => element.count > 0);

          final text = res
              .map((e) => '${e.name}- ${e.count} ${e.name.contains('.') ? 'kaset' : 'blok'}')
              .toList()
              .toString()
              .replaceAll(',', '\n')
              .replaceAll('Text', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .replaceAll('[', '')
              .replaceAll('(', '')
              .replaceAll(')', '');

          if (res.isNotEmpty) {
            await Share.share(kioskName + text);
          } else {
            null;
          }
        },
        style: ElevatedButton.styleFrom(
            primary: Colors.blue[180], shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10)),
        child: Text(
          'Göndər',
          style: italicFontStyle(),
        ));
  }

  String get kioskName => 'Sabahınız xeyir \n \n <<<${textEditingController.value.text}>>> \n \n ';

  LinearGradient _colorBluePurple() {
    return const LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: <Color>[Colors.purple, Colors.blue]);
  }

  IconButton _removeCountButton(ProductItem productItems) {
    return IconButton(
      onPressed: () => removeCount(productItems),
      icon: const Icon(Icons.remove),
    );
  }

  IconButton _addCountButton(ProductItem productItems) {
    return IconButton(
      onPressed: () => addCount(productItems),
      icon: const Icon(Icons.add),
    );
  }

  Text _countText(ProductItem productItems) => Text(
        '${productItems.count}',
        style: italicFontStyle(),
      );

  TextStyle italicFontStyle() => const TextStyle(fontStyle: FontStyle.italic);

  void addCount(ProductItem productItems) {
    setState(() {
      productItems.count = productItems.count + 1;
    });
  }

  void removeCount(ProductItem productItems) {
    if (productItems.count > 0) {
      setState(() {
        productItems.count = productItems.count - 1;
      });
    } else {
      null;
    }
  }
}
