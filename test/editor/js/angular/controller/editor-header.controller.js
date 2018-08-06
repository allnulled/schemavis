angular.module("LanguageCreatorApp").controller("EditorHeaderCtrl", [
  "$scope",
  "$rootScope",
  "$log",
  "$timeout",
  "LanguageCreatorService",
  function($scope, $rootScope, $log, $timeout, LanguageCreatorService) {
    const ctrl = this;
    ctrl.widgets = [];
    ctrl.markers = [];
    function onChangeForInputEditorFunc(editor) {
      console.log(editor.getValue().length + " characters in the editor.");
      ctrl.widgets.forEach((widget) => editor.removeLineWidget(widget));
      ctrl.markers.forEach((marker) => marker.clear());
      widgets = [];
      markers = [];
      localStorage.LanguageCreator_InputMemory = editor.getValue();
      try {
        const parsedValue = LanguageCreatorService.parse(editor.getValue());
        if(typeof parsedValue === "string") {
          ctrl.editors.output.value = parsedValue;
        } else {
          ctrl.editors.output.value = JSON.stringify(parsedValue, null, 2);
        }
      } catch (exc) {
        console.log(exc);
        ctrl.editors.output.value = JSON.stringify(exc, null, 2);
        const err = document.createElement("div");
        err.appendChild(document.createTextNode(exc.message));
        err.className = "lint-error";
        ctrl.widgets.push(editor.addLineWidget(exc.location.start.line - 1, err, {
          coverGutter: false,
          noHScroll: true
        }));
        ctrl.markers.push(editor.getDoc().markText({
          line: exc.location.start.line - 1,
          ch: exc.location.start.column -1
        }, {
          line: exc.location.start.line -1,
          ch: exc.location.start.column - 1 + (exc.found ? exc.found.length : 0)
        }, {
          className: "editor-error-custom"
        }));
      }
    };

    function onLoadForInputEditorFunc(editor) {
      editor.on("change", onChangeForInputEditorFunc);
      editor.setValue(localStorage.LanguageCreator_InputMemory ? localStorage.LanguageCreator_InputMemory : "")
    };
    ctrl.ui = {};
    ctrl.ui.state = {};
    ctrl.ui.state.inputEditor = {};
    ctrl.ui.state.inputEditor.hide = false;
    ctrl.ui.state.outputEditor = {};
    ctrl.ui.state.outputEditor.hide = false;
    ctrl.ui.state.outputMode = "visualization";
    ctrl.editors = {};
    ctrl.editors.defaults = {};
    ctrl.editors.defaults.options = {
      lineWrapping: true,
      lineNumbers: true,
      theme: "abcdef",
    };
    ctrl.editors.input = {};
    ctrl.editors.input.value = "";
    ctrl.editors.input.options = Object.assign({}, ctrl.editors.defaults.options, {
      onLoad: onLoadForInputEditorFunc
    });
    ctrl.editors.output = {};
    ctrl.editors.output.value = "";
    ctrl.editors.output.options = Object.assign({}, ctrl.editors.defaults.options, {});
    window.ctrl = ctrl;
  }
])