package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.editor.EditorMenuBar;
    import com.joeberkovitz.moccasin.event.SelectEvent;
    import com.joeberkovitz.simpleworld.controller.AppController;
    
    /**
     * Application specific menu bar.
     */
    public class AppMenuBar extends EditorMenuBar
    {
        public function AppMenuBar()
        {
            super();
        }
        
        public function get simpleController():AppController
        {
            return editor.controller as AppController;
        }
        
        public function get simpleEditor():AirAppEditor
        {
            return editor as AirAppEditor;
        }
        
        override protected function initializeMenuItems():void
        {
            super.initializeMenuItems();
            
            menuBarDefinition +=
                <menuitem id="simpleWorld" label="SoundWorld">
                    <menuitem id="addSquare" label="Add Square"/>
                    <menuitem id="setColor" label="Change Color" enabled="false" />
                    <menuitem id="rotateSquare" label="Rotate Square" />
                </menuitem>;

            menuBarDefinition +=
                <menuitem id="performance" label="Performance">
                    <menuitem id="play" label="Play"/>
                </menuitem>;
        }
        
        override protected function handleChangeSelection(evt:SelectEvent):void
        {
            var colorMenu:XMLList = menuBarDefinition[2].menuitem.(@id=="setColor");
            
            // Disable setColor menu item if nothing is selected
            if (evt.selection==null || evt.selection.selectedModels.length==0)
                colorMenu[0].@enabled="false";
            else
            {
                colorMenu[0].@enabled="true";
            }
        }
        
        override protected function handleCommand(commandName:String):void
        {
            switch(commandName)
            {
            case "addSquare":
                simpleController.document.undoHistory.openGroup("Add Square");
                simpleController.addObject();
                break;
            case "setColor":
                simpleController.document.undoHistory.openGroup("Change Color");
                simpleController.changeColor();
                break;
            case "rotateSquare":
                simpleController.document.undoHistory.openGroup("Rotate Square");
                simpleController.rotateSquare(Math.PI / 8);
                break;
            case "play":
                simpleEditor.startPlayback();
                break;
            case "stop":
                simpleEditor.stopPlayback();
                break;
                
            default:
                super.handleCommand(commandName);
            }
        }
    }
}
