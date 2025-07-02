import 'dart:io' show File;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/feature/home_feature/main_page.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/src/domain/model/model.dart';

part 'components/app_bar.dart';

part 'components/body.dart';

part 'components/empty_view.dart';

part 'components/list_tile.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            _AppBar(_textEditingController),
            _BodyView(_scrollController),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
