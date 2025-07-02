part of '../editor_page.dart';

mixin _StateHelper on State<EditorPage> {
  I18n? _localizations;
  Uint8List? editedBytes;
  bool isPreCached = true;
  bool _deviceCanVibrate = false;
  late final ScannerBloc _scannerBloc;
  bool _deviceCanCustomVibrate = false;
  final editorKey = GlobalKey<ProImageEditorState>();

  @override
  void initState() {
    super.initState();

    isPreCached = false;
    Vibration.hasVibrator().then((hasVibrator) async {
      _deviceCanVibrate = hasVibrator;

      if (!hasVibrator || !mounted) return;

      _deviceCanCustomVibrate = await Vibration.hasCustomVibrationsSupport();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _scannerBloc = context.read<ScannerBloc>();
      precacheImage(FileImage(File(widget.path)), context).whenComplete(() {
        if (!mounted) return;
        isPreCached = true;
        setState(() {});
      });
    });
  }

  Future<void> onImageEditingComplete(Uint8List bytes) async {
    editedBytes = bytes;
  }

  Future<void> onCloseEditor(EditorMode editorMode) async {
    if (editorMode != EditorMode.main) return Navigator.pop(context);

    if (editedBytes != null) {
      final cached = editedBytes!;
      await precacheImage(MemoryImage(cached), context);
      if (!mounted) return;
      editorKey.currentState?.isPopScopeDisabled = true;
      _scannerBloc.add(
        ScannerEvent.overwriteScan(
          editedImageBytes: cached,
          path: widget.path,
          thumbnailPath: widget.thumbnailPath,
          group: widget.group,
        ),
      );
      Future(() {
        editedBytes = null;
      }).ignore();
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void vibrateLineHit() {
    if (_deviceCanVibrate && _deviceCanCustomVibrate) {
      Vibration.vibrate(duration: 3);
    } else if (!kIsWeb && Platform.isAndroid) {
      /// On old android devices we can stop the vibration after 3 milliseconds
      /// iOS: only works for custom haptic vibrations using CHHapticEngine.
      /// This will set `deviceCanCustomVibrate` anyway to true so it's
      /// impossible to fake it.
      Vibration.vibrate();
      Future.delayed(
        const Duration(milliseconds: 3),
      ).whenComplete(Vibration.cancel);
    }
  }

  I18n get _localization {
    return _localizations ??= I18n(
      layerInteraction: I18nLayerInteraction(
        remove: LocaleKeys.remove.tr(),
        edit: LocaleKeys.edit.tr(),
        rotateScale: LocaleKeys.rotateScale.tr(),
      ),
      paintEditor: I18nPaintEditor(
        moveAndZoom: LocaleKeys.moveAndZoom.tr(),
        bottomNavigationBarText: LocaleKeys.paint.tr(),
        freestyle: LocaleKeys.freestyle.tr(),
        arrow: LocaleKeys.arrow.tr(),
        line: LocaleKeys.line.tr(),
        rectangle: LocaleKeys.rectangle.tr(),
        circle: LocaleKeys.circle.tr(),
        dashLine: LocaleKeys.dashLine.tr(),
        polygon: LocaleKeys.polygon.tr(),
        blur: LocaleKeys.blur.tr(),
        pixelate: LocaleKeys.pixelate.tr(),
        lineWidth: LocaleKeys.lineWidth.tr(),
        eraser: LocaleKeys.eraser.tr(),
        toggleFill: LocaleKeys.toggleFill.tr(),
        changeOpacity: LocaleKeys.changeOpacity.tr(),
        undo: LocaleKeys.undo.tr(),
        redo: LocaleKeys.redo.tr(),
        done: LocaleKeys.done.tr(),
        back: LocaleKeys.back.tr(),
        smallScreenMoreTooltip: LocaleKeys.more.tr(),
      ),
      textEditor: I18nTextEditor(
        inputHintText: LocaleKeys.inputHintText.tr(),
        bottomNavigationBarText: LocaleKeys.text.tr(),
        back: LocaleKeys.back.tr(),
        done: LocaleKeys.done.tr(),
        textAlign: LocaleKeys.textAlign.tr(),
        fontScale: LocaleKeys.fontScale.tr(),
        backgroundMode: LocaleKeys.backgroundMode.tr(),
        smallScreenMoreTooltip: LocaleKeys.more.tr(),
      ),
      cropRotateEditor: I18nCropRotateEditor(
        bottomNavigationBarText: LocaleKeys.cropRotate.tr(),
        rotate: LocaleKeys.rotate.tr(),
        flip: LocaleKeys.flip.tr(),
        ratio: LocaleKeys.ratio.tr(),
        back: LocaleKeys.back.tr(),
        done: LocaleKeys.done.tr(),
        cancel: LocaleKeys.cancel.tr(),
        undo: LocaleKeys.undo.tr(),
        redo: LocaleKeys.redo.tr(),
        smallScreenMoreTooltip: LocaleKeys.more.tr(),
        reset: LocaleKeys.reset.tr(),
      ),
      tuneEditor: I18nTuneEditor(
        bottomNavigationBarText: LocaleKeys.tune.tr(),
        back: LocaleKeys.back.tr(),
        done: LocaleKeys.done.tr(),
        brightness: LocaleKeys.brightness.tr(),
        contrast: LocaleKeys.contrast.tr(),
        saturation: LocaleKeys.saturation.tr(),
        exposure: LocaleKeys.exposure.tr(),
        hue: LocaleKeys.hue.tr(),
        temperature: LocaleKeys.temperature.tr(),
        sharpness: LocaleKeys.sharpness.tr(),
        fade: LocaleKeys.fade.tr(),
        luminance: LocaleKeys.luminance.tr(),
        undo: LocaleKeys.undo.tr(),
        redo: LocaleKeys.redo.tr(),
      ),
      filterEditor: I18nFilterEditor(
        bottomNavigationBarText: LocaleKeys.filter.tr(),
        back: LocaleKeys.back.tr(),
        done: LocaleKeys.done.tr(),
        filters: I18nFilters(
          none: LocaleKeys.noFilter.tr(),
          addictiveBlue: LocaleKeys.addictiveBlue.tr(),
          addictiveRed: LocaleKeys.addictiveRed.tr(),
          aden: LocaleKeys.aden.tr(),
          amaro: LocaleKeys.amaro.tr(),
          ashby: LocaleKeys.ashby.tr(),
          brannan: LocaleKeys.brannan.tr(),
          brooklyn: LocaleKeys.brooklyn.tr(),
          charmes: LocaleKeys.charmes.tr(),
          clarendon: LocaleKeys.clarendon.tr(),
          crema: LocaleKeys.crema.tr(),
          dogpatch: LocaleKeys.dogpatch.tr(),
          earlybird: LocaleKeys.earlybird.tr(),
          f1977: LocaleKeys.f1977.tr(),
          gingham: LocaleKeys.gingham.tr(),
          ginza: LocaleKeys.ginza.tr(),
          hefe: LocaleKeys.hefe.tr(),
          helena: LocaleKeys.helena.tr(),
          hudson: LocaleKeys.hudson.tr(),
          inkwell: LocaleKeys.inkwell.tr(),
          juno: LocaleKeys.juno.tr(),
          kelvin: LocaleKeys.kelvin.tr(),
          lark: LocaleKeys.lark.tr(),
          loFi: LocaleKeys.loFi.tr(),
          ludwig: LocaleKeys.ludwig.tr(),
          maven: LocaleKeys.maven.tr(),
          mayfair: LocaleKeys.mayfair.tr(),
          moon: LocaleKeys.moon.tr(),
          nashville: LocaleKeys.nashville.tr(),
          perpetua: LocaleKeys.perpetua.tr(),
          reyes: LocaleKeys.reyes.tr(),
          rise: LocaleKeys.rise.tr(),
          sierra: LocaleKeys.sierra.tr(),
          skyline: LocaleKeys.skyline.tr(),
          slumber: LocaleKeys.slumber.tr(),
          stinson: LocaleKeys.stinson.tr(),
          sutro: LocaleKeys.sutro.tr(),
          toaster: LocaleKeys.toaster.tr(),
          valencia: LocaleKeys.valencia.tr(),
          vesper: LocaleKeys.vesper.tr(),
          walden: LocaleKeys.walden.tr(),
          willow: LocaleKeys.willow.tr(),
          xProII: LocaleKeys.xProII.tr(),
        ),
      ),
      blurEditor: I18nBlurEditor(
        bottomNavigationBarText: LocaleKeys.blur.tr(),
        back: LocaleKeys.back.tr(),
        done: LocaleKeys.done.tr(),
      ),
      emojiEditor: I18nEmojiEditor(
        bottomNavigationBarText: LocaleKeys.emoji.tr(),
        search: LocaleKeys.search.tr(),
        categoryRecent: LocaleKeys.categoryRecent.tr(),
        categorySmileys: LocaleKeys.categorySmileys.tr(),
        categoryAnimals: LocaleKeys.categoryAnimals.tr(),
        categoryFood: LocaleKeys.categoryFood.tr(),
        categoryActivities: LocaleKeys.categoryActivities.tr(),
        categoryTravel: LocaleKeys.categoryTravel.tr(),
        categoryObjects: LocaleKeys.categoryObjects.tr(),
        categorySymbols: LocaleKeys.categorySymbols.tr(),
        categoryFlags: LocaleKeys.categoryFlags.tr(),
        locale: EasyLocalization.of(context)?.currentLocale,
        enableSearchAutoI18n: true,
      ),
      stickerEditor: I18nStickerEditor(
        bottomNavigationBarText: LocaleKeys.stickers.tr(),
      ),
      various: I18nVarious(
        loadingDialogMsg: LocaleKeys.loadingDialogMsg.tr(),
        closeEditorWarningTitle: LocaleKeys.closeEditorWarningTitle.tr(),
        closeEditorWarningMessage: LocaleKeys.closeEditorWarningMessage.tr(),
        closeEditorWarningConfirmBtn: LocaleKeys.closeEditorWarningConfirmBtn
            .tr(),
        closeEditorWarningCancelBtn: LocaleKeys.closeEditorWarningCancelBtn
            .tr(),
      ),

      cancel: LocaleKeys.cancel.tr(),
      undo: LocaleKeys.undo.tr(),
      redo: LocaleKeys.redo.tr(),
      done: LocaleKeys.done.tr(),
      remove: LocaleKeys.remove.tr(),
      doneLoadingMsg: LocaleKeys.doneLoadingMsg.tr(),
    );
  }
}
