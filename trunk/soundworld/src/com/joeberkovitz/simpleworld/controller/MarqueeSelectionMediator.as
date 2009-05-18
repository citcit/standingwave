package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.SonicElement;
    import com.joeberkovitz.simpleworld.model.Tone;
    import com.joeberkovitz.simpleworld.view.CompositionView;
    
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * Mediator for the WorldView that adds a new tone at a clicked location, but for
     * a drag gesture draws a marquee rectangle that selects enclosed objects.
     */
    public class MarqueeSelectionMediator extends DragMediator
    {
        private var _worldView:CompositionView;
        private var _marquee:Shape;
        private var _worldStart:Rectangle;
        private var _worldDragRect:Rectangle;
        
        public function MarqueeSelectionMediator(context:ViewContext, worldView:CompositionView)
        {
            super(context);
            _worldView = worldView;
        }
        
        override protected function handleClick(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Add Tone");
            
            var tone:Tone = new Tone();
            tone.x = e.localX;
            tone.y = e.localY;
            tone.width = 100;
            tone.height = 25;
            _worldView.world.elements.addItem(tone);

            context.controller.selectSingleModel(MoccasinModel.forValue(tone));
        }
        
        /**
         * At the start of a drag, capture the sizes of all selected shapes so that we
         * can resize them all by the same delta later on.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Select Elements");
            
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
            
            var selectedElements:Array = [];
            for each (var ws:SonicElement in _worldView.world.elements)
            {
                if (ws.bounds.intersects(_worldDragRect))
                {
                	selectedElements.push(MoccasinModel.forValue(ws));
                }
            }
            context.controller.modifyMultiSelection(selectedElements);
        }
        
        private function get dragEndpointRect():Rectangle
        {
            return new Rectangle(_worldView.mouseX, _worldView.mouseY, 1, 1)
        }
   }
}
