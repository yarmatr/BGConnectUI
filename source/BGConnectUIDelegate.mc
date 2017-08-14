using Toybox.WatchUi as Ui;

class BGConnectUIDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new BGConnectUIMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}