import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testnotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  // to show the overlay
  void show({
    required BuildContext context,
    required String text,
  }) {
    /// or you could rewrite the code below as
    /// if(controller != null){
    /// return update(text);
    /// }
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  // to hide the overlay
  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // we need to create a streamController that are provided by the
    // controllers in the sense that if the someone updates the loadingScreen
    // text then it would put the strings inside the streamController

    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    // the renderBox is used to render the overlay on the device
    // while considering the screen size of the device
    // it is used to extract available size that the overlay can render on the screen

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                // this is ssaying that the dialog to be displayed on the screen
                // is going to consume at most 80% of the available width
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            // you can also retrun an empty Text('');
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // to display the overlay, you do the below
    state?.insert(overlay);

    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
