import 'package:codewrap/repo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'demo_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Repo> _repoList;
  late Repo _selectedRepo;

  @override
  void initState() {
    super.initState();
    _repoList = DemoData.getRepos();
    _selectedRepo = _repoList[0];
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color.fromARGB(24, 255, 255, 255),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.menu, color: Colors.white)),
      toolbarHeight: 100,
      title: Image.asset(
        'images/logo.png',
        height: 50,
      ),
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Styles.hzScreenPadding),
          child: Icon(Icons.search, color: Colors.white),
        )
      ],
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RepoList(
            repos: _repoList,
            onChange: _handleChange,
          ),
        ],
      ),
    );
  }

  void _handleChange(Repo repo) {
    setState(() {
      _selectedRepo = repo;
    });
  }
}

class Styles {
  static const double hzScreenPadding = 18;
}
