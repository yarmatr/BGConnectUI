using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BGConnectUIMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            Sys.println("item blah");
        } else if (item == :item_2) {
            Sys.println("item 2");
        }
    }

}