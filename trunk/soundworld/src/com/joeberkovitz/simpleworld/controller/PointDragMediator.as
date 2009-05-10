package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.view.IMoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * Mediator to resize a shape. 
     */
    public class PointDragMediator extends DragMediator
    {
        private var _value:Object;
        private var _oldPoint:Point;
        private var _propertyName:String;
        
        public var groupName:String = "Drag Point";
        
        public function PointDragMediator(context:ViewContext, propertyName:String, value:Object = null)
        {
            super(context);
            _propertyName = propertyName;
            _value = value;
        }
        
        /**
         * When asked to work with a LineFeedback, take note of the view and add a listener for mouseDown.
         */
        public function handleViewEvents(view:IMoccasinView, handle:DisplayObject):void
        {
            _value = view.model.value;
            handle.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        /**
         * At the start of a drag, capture the size the selected shape.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            if (groupName)
            {
                context.controller.document.undoHistory.openGroup(groupName);
            }
            _oldPoint = _value[_propertyName];
        }
        
        /**
         * For each move during the drag, resize the model appropriately.
         */
        override protected function handleDragMove(e:MouseEvent):void
        {
            _value[_propertyName] = _oldPoint.add(documentDragDelta);
        }
    }
}