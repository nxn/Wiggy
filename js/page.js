(function() {
  Wiggy.dom(createButtons);
  Wiggy.dom(createButtonGroups);
  Wiggy.dom(createTabPanel);
  Wiggy.dom(createWindow);
  Wiggy.dom(createCheckboxes);
  Wiggy.dom(createRadiobuttons);
  Wiggy.dom(createFields);

  function createFields() {
    var $container = Wiggy.dom('#fldContainer')
      , widgets = 
        [ { widget: Wiggy.ui.Searchfield
          , element: { parent: $container }
          }
        , { widget: Wiggy.ui.Textfield
          , element: { parent: $container }
          , labelText: 'Textfield example'
          , showLabel: false
          }
        , { widget: Wiggy.ui.Textarea
          , element: { parent: $container }
          , labelText: 'Textarea example'
          , showLabel: false
          }
        ]

    Wiggy.make(widgets).each(function(widget) {
      widget.show();
      $container.append('<br />');
    });
  }
  
  function createButtons() {
    var container = Wiggy.dom('#btnContainer')[0]
    var buttons =
        [ { widget: Wiggy.ui.Button
          , element: { parent: container }
          , text: "Regular"
          , click: function() { }
          }
        , btn2 =
          { widget: Wiggy.ui.Button
          , element: { parent: container, nodeType: 'a' }
          , text: "Link"
          , click: function() { }
          }
        , btn3 =
          { widget: Wiggy.ui.Button
          , element: { parent: container, nodeType: 'input' }
          , text: "Input"
          , click: function() { }
          }
        , btn4 =
          { widget: Wiggy.ui.Button
          , element: { parent: container }
          , text: "Disabled"
          , click: function() { }
          , disabled: true
          }
        ]

    Wiggy.make(buttons).each(function(widget) {
      widget.show();
    });
  }
  
  function createButtonGroups() {
    var $container = Wiggy.dom('#btngrpContainer')
      , tpl =
          '<h4> \
             <span class="bold">Selections</span> \
             Min: <span class="bold">{0}</span>, \
             Max: <span class="bold">{1}</span> \
           </h4>'
      , newButtonGroup = function(min, max, selected) {
          $container.append(Wiggy.format(tpl, min, max));
          return Wiggy.make(
            { widget: Wiggy.ui.ButtonGroup
            , element: { parent: $container[0] }
            , minSelect: min
            , maxSelect: max
            , selected: selected
            , items:
              [ { text: 'Option 1' }
              , { text: 'Option 2' }
              , { text: 'Option 3' }
              , { text: 'Option 4' }
              ]
            }
          ).show()
        };
  
    newButtonGroup(0, 0).items.get(3).disable().setText('Disabled');
    newButtonGroup(0, 4, [0,1,2,3]);
    newButtonGroup(1, 1, 0);
    newButtonGroup(2, 3, [0,2]);
  }
  
  function createTabPanel() {
    var panels = [];
    for (var i = 1; i <= 4; i++) {
      panels.push(
        { title: 'Panel ' + i
        , blueprint: '| [content] |'
        , items:
          { content:
            { widget: Wiggy.ui.Element
            , html: Wiggy.dom("#pnlData" + i).html()
            }
          }
        }
      );
    }

    Wiggy.make(
      { widget: Wiggy.ui.TabPanel
      , element: { parent: Wiggy.dom('#tpContainer') }
      , items: panels
      }
    ).show();
  }
  
  function createWindow() {
    var win = Wiggy.make(
      { widget: Wiggy.ui.Window
      , x: 362
      , y: 380
      , width: 580
      , height: 200
      , titlebar: { text: 'Welcome' }
      , body:
        { blueprint:
          '|-15-[ msg               ]-15-|' +
          '|        [ lbl ]-8-[ btn ]-15-|'
        , items:
          { btn:
            { widget: Wiggy.ui.Button
            , text: 'Button Text'
            }
          , lbl:
            { widget: Wiggy.ui.Element
            , html: 'Label Text'
            }
          , msg:
            { widget: Wiggy.ui.Element
            , html: 'Message Text'
            }
          }
        }
      }
    ).show();
  }

  function createCheckboxes() {
    var configs =
      [ { labelText: 'Option 1', name: 'opt', checked: true }
      , { labelText: 'Option 2', name: 'opt' }
      , { labelText: 'Option 3', name: 'opt' }
      , { labelText: 'Disabled', name: 'opt', disabled: true }
      ]
    , $container = Wiggy.dom('#chkboxContainer')

    for (var i = 0, config; config = configs[i]; i++) {
      config.element = { parent: $container };
      config.widget = Wiggy.ui.Checkbox
      Wiggy.make(config).show();
      $container.append('<br />');
    }
  }

  function createRadiobuttons() {
    var configs =
      [ { labelText: 'Option 1', name: 'opt2', checked: true }
      , { labelText: 'Option 2', name: 'opt2' }
      , { labelText: 'Option 3', name: 'opt2' }
      , { labelText: 'Disabled', name: 'opt2', disabled: true }
      ]
    , $container = Wiggy.dom('#rdbContainer')

    for (var i = 0, config; config = configs[i]; i++) {
      config.element = { parent: $container };
      config.widget = Wiggy.ui.Radiobutton
      Wiggy.make(config).show();
      $container.append('<br />');
    }
  }
})();
