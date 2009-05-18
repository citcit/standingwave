package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.SonicElement;
    import com.joeberkovitz.simpleworld.view.SonicElementView;
    import com.joeberkovitz.simpleworld.view.SoundClipView;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * Mediator to drag selected sonic elements from one place to another. 
     */
    public class ElementDragMediator extends DragMediator
    {
        private var _elementView:SonicElementView;
        private var _oldPositions:Array; /* of points */
        
        public function ElementDragMediator(context:ViewContext)
        {
            super(context);
        }
        
        /**
         * When asked to work with a SonicElementView, take note of the view and add a listener for mouseDown.
         */
        public function handleViewEvents(view:SonicElementView):void
        {
            _elementView = view;
            _elementView.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        /**
         * At the start of a drag, capture the positions of all selected elements so that we
         * can move them all by the same delta later on.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Move Elements");
            if (!context.controller.selection.contains(_elementView.model))
            {
                context.controller.selectSingleModel(_elementView.model);
            }
            
            _oldPositions = [];
            for each (var m:MoccasinModel in context.controller.selection.selectedModels)
            {
                var sm:SonicElement = SonicElement(m.value);
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
                var sm:SonicElement = SonicElement(m.value);
                var newPosition:Point = Point(_oldPositions[i++]).add(documentDragDelta); 
                sm.x = newPosition.x;
                sm.y = newPosition.y;
            }
        }
    }
}