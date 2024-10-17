import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> news = [];
  bool loading = false;
  int currentPage = 1;
  late ScrollController controller;

  loadNews({int page = 1}) async {
    setState(() {
      loading = true;
    });
    if (page != 1) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }

    Dio dio = Dio();
    var response =
        await dio.get('https://www.nginx.com/wp-json/wp/v2/posts?page=$page');
    if (response.statusCode == 200) {
      print(response.data);
      if (page == 1) {
        news = response.data;
      } else {
        news.addAll(response.data);
      }
      currentPage = page;
      loading = false;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Hata oluştu')));
      setState(() {
        loading = false;
      });
    }
  }

  Widget getNews() {
    if (news.isNotEmpty) {
      var haberler = news
          .map((e) => Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: e["yoast_head_json"]["twitter_image"] != null
                            ? Image.network(
                                e["yoast_head_json"]["twitter_image"])
                            : Image.network(
                                'https://i0.wp.com/learn.onemonth.com/wp-content/uploads/2017/08/1-10.png?fit=845%2C503&ssl=1',
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      e["yoast_head_json"]?["title"] ?? 'Title Not Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.8),
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Text(
                      e["yoast_head_json"]?["description"] ??
                          'Description Not Found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ))
          .toList();
      return Column(
        children: haberler,
      );
    } else {
      return Text('Loading');
    }
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      loadNews(page: currentPage + 1);
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {}
  }

  @override
  void initState() {
    super.initState();
    loadNews();
    controller = ScrollController();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('News'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              child: Icon(Iconsax.setting_2),
              onTap: () => GoRouter.of(context).push('/settings'),
            ),
          ),
        ],
      ),
      body: Theme(
        data: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(
                isDarkMode ? Colors.grey[400] : Colors.black),
          ),
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          thickness: 8,
          radius: Radius.circular(4),
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                getNews(),
                loading ? LinearProgressIndicator() : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
