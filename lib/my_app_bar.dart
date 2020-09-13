import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/theme_change_bloc.dart';
import 'bloc/theme_change_event.dart';
import 'bloc/theme_change_state.dart';

AppBar myAppBar() => AppBar(
      elevation: 1.0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Light Mode",
            style: TextStyle(fontSize: 12),
          ),
          BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
            builder: (context, state) {
              return Switch(
                  value: state.themeState.isLightMode,
                  onChanged: (value) =>
                      BlocProvider.of<ThemeChangeBloc>(context)
                          .add(OnThemeChangedEvent(value)));
            },
          )
        ],
      ),
    );
