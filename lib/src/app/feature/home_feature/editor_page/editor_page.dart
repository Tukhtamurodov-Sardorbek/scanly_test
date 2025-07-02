import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/colors/app_color.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:vibration/vibration.dart';

part 'components/mixin.dart';

@RoutePage()
class EditorPage extends StatefulWidget {
  final String path;
  final String? thumbnailPath; // If the picture is the first picture in group
  final ScanGroup group;

  const EditorPage({
    super.key,
    required this.path,
    required this.group,
    required this.thumbnailPath,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> with _StateHelper {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: ProImageEditor.file(
          File(widget.path),
          callbacks: ProImageEditorCallbacks(
            onCloseEditor: (mode) => onCloseEditor(mode),
            onImageEditingComplete: onImageEditingComplete,
            mainEditorCallbacks: MainEditorCallbacks(
              helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
            ),
          ),
          configs: ProImageEditorConfigs(
            i18n: _localization,
            heroTag: widget.path,
            designMode: ImageEditorDesignMode.cupertino,
            // platformDesignMode,
            stickerEditor: StickerEditorConfigs(enabled: true),
            mainEditor: MainEditorConfigs(
              enableZoom: true,
              editorMaxScale: 5,
              editorMinScale: 0.8,
              enableCloseButton: true,
              enableDoubleTapZoom: true,
              boundaryMargin: const EdgeInsets.all(80),
              widgets: MainEditorWidgets(
                bodyItems: (editor, rebuildStream) {
                  return [
                    ReactiveWidget(
                      stream: rebuildStream,
                      builder: (_) =>
                          editor.selectedLayerIndex >= 0 ||
                              editor.isSubEditorOpen
                          ? const SizedBox.shrink()
                          : Positioned(
                              bottom: 20,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.primaryTone.withValues(
                                    alpha: 0.7,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100),
                                  ),
                                ),
                                child: GestureInterceptor(
                                  child: IconButton(
                                    onPressed: editor.resetZoom,
                                    icon: const Icon(
                                      Icons.zoom_out_map_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ];
                },
              ),
            ),
            paintEditor: const PaintEditorConfigs(
              enableZoom: true,
              editorMaxScale: 5,
              editorMinScale: 0.8,
              boundaryMargin: EdgeInsets.all(80),
              icons: PaintEditorIcons(moveAndZoom: Icons.pinch_outlined),
            ),
            textEditor: TextEditorConfigs(
              showSelectFontStyleBottomBar: true,
              customTextStyles: [
                GoogleFonts.lato(),
                GoogleFonts.actor(),
                GoogleFonts.roboto(),
                GoogleFonts.comicNeue(),
                GoogleFonts.averiaLibre(),
                GoogleFonts.odorMeanChey(),
              ],
            ),
            emojiEditor: EmojiEditorConfigs(
              enabled: true,
              checkPlatformCompatibility: false,
              style: EmojiEditorStyle(
                textStyle: DefaultEmojiTextStyle.copyWith(
                  fontFamily: GoogleFonts.notoColorEmoji().fontFamily,
                ),
              ),
            ),
            // progressIndicatorConfigs: ProgressIndicatorConfigs(
            //   widgets: ProgressIndicatorWidgets(
            //     circularProgressIndicator: LoadingView(),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
