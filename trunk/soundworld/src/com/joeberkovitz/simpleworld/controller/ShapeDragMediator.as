package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.event.DocumentUpdateEvent;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.WorldShape;
    import com.joeberkovitz.simpleworld.view.ShapeView;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * Mediator to drag selected shapes from one place to another. 
     */
    public class ShapeDragMediator extends DragMediator
    {
        private var _shapeView:ShapeView;
        private var _oldPositions:Array; /* of points */
        
        public function ShapeDragMediator(context:ViewContext)
        {
            super(context);
        }
        
        /**
         * When asked to work with a ShapeView, take note of the view and add a listener for mouseDown.
         */
        public function handleViewEvents(view:ShapeView):void
        {
            _shapeView = view;
            _shapeView.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        /**
         * At the start of a drag, capture the positions of all selected shapes so that we
         * can move them all by the same delta later on.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Move Shapes");
            if (!context.controller.selection.contains(_shapeView.model))
            {
                context.controller.selectSingleModel(_shapeView.model);
            }
            
            _oldPositions = [];
            for each (var m:MoccasinModel in context.controller.selection.selectedModels)
            {
                var sm:WorldShape = WorldShape(m.value);
                _oldPositions.push(new Point(sm.x, sm.y));
            }
        }
        
        /**
         * For each move during the drag, position the models appropriately given the drag distance
         * from the starting point.
         */
        override protected function handleDragMove(e:MouseEvent):void
        {
            var i:int = 0;
            for each (var m:MoccasinModel in context.controller.selection.selectedModels)
            {
                var sm:WorldShape = WorldShape(m.value);
                var newPosition:Point = Point(_oldPositions[i++]).add(documentDragDelta); 
                sm.x = newPosition.x;
                sm.y = newPosition.y;
            }
        }
    }
}