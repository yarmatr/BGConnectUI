using Toybox.WatchUi as Ui;

class FirstProjectDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new FirstProjectMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}