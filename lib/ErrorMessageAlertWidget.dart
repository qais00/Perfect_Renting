import 'dart:async';
import 'package:flutter/material.dart';
import 'package:perfect_renting/ModalController.dart';

class ErrorMessageAlertWidget {
  factory ErrorMessageAlertWidget() => _shared;
  static final ErrorMessageAlertWidget _shared = ErrorMessageAlertWidget._sharedInstance();

  ErrorMessageAlertWidget._sharedInstance();

  ModalController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  ModalController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                  maxHeight: size.height * 0.8,
                  minWidth: size.width * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        StreamBuilder(
                          stream: _text.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _shared.hide(),
                          child: Text(
                            "OK",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).secondaryHeaderColor,
                            shape: StadiumBorder()
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );

    state.insert(overlay);

    return ModalController(
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