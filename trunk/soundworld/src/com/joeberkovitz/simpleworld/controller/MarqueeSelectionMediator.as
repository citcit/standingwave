package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.WorldShape;
    import com.joeberkovitz.simpleworld.view.WorldView;
    
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * Mediator for the WorldView that adds a new square at a clicked location, but for
     * a drag gesture draws a marquee rectangle that selects enclosed objects.
     */
    public class MarqueeSelectionMediator extends DragMediator
    {
        private var _worldView:WorldView;
        private var _marquee:Shape;
        private var _worldStart:Rectangle;
        private var _worldDragRect:Rectangle;
        
        public function MarqueeSelectionMediator(context:ViewContext, worldView:WorldView)
        {
            super(context);
            _worldView = worldView;
        }
        
        override protected function handleClick(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Add Square");
            
            var square:Square = new Square();
            square.x = e.localX;
            square.y = e.localY;
            square.size = 25;
            square.color = 0;
            _worldView.world.shapes.addItem(square);

            context.controller.selectSingleModel(MoccasinModel.forValue(square));
        }
        
        /**
         * At the start of a drag, capture the sizes of all selected shapes so that we
         * can resize them all by the same delta later on.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Select Shapes");
            
            _marquee = new Shape();
            context.editor.feedbackLayer.addChild(_marquee);
            
            _worldStart = dragEndpointRect;
        }
        
        /**
         * For each move during the drag, resize the models appropriately.
         */
        override protected function handleDragMove(e:MouseEvent):void
        {
            _worldDragRect = _worldStart.union(dragEndpointRect);
            
            _marquee.graphics.clear();
            _marquee.graphics.lineStyle(1, 0, 0.5);
            _marquee.graphics.drawRect(_worldDragRect.x, _worldDragRect.y, _worldDragRect.width, _worldDragRect.height);
        }

        override protected function handleDragEnd(e:MouseEvent):void
        {
            context.editor.feedbackLayer.removeChild(_marquee);
            _marquee = null;
            
            if (!e.ctrlKey)
                context.controller.clearSelection();
            
            var selectedShapes:Array = [];
            for each (var ws:WorldShape in _worldView.world.shapes)
            {
                if (ws.bounds.intersects(_worldDragRect))
                {
                	selectedShapes.push(MoccasinModel.forValue(ws));
                }
            }
            context.controller.modifyMultiSelection(selectedShapes);
        }
        
        private function get dragEndpointRect():Rectangle
        {
            return new Rectangle(_worldView.mouseX, _worldView.mouseY, 1, 1)
        }
   }
}
