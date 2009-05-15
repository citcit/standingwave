package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.Line;
    import com.joeberkovitz.simpleworld.view.WorldView;
    
    import flash.events.MouseEvent;

    /**
     * Mediator for the WorldView that adds a new square at a clicked location, but for
     * a drag gesture draws a marquee rectangle that selects enclosed objects.
     */
    public class WorldMediator extends DragMediator
    {
        private var _worldView:WorldView;
        
        public function WorldMediator(context:ViewContext)
        {
            super(context);
        }
        
        /**
         * When asked to work with a ShapeView, take note of the view and add a listener for mouseDown.
         */
        public function handleViewEvents(view:WorldView):void
        {
            _worldView = view;
            view.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        override public function handleMouseDown(e:MouseEvent):void
        {
            if (e.shiftKey)
            {
                context.controller.document.undoHistory.openGroup("Create Line");
                var line:Line = AppController(context.controller).addLine();
                line.x = e.localX;
                line.y = e.localY;
                line.width = line.height = 0;
                var mediator:PointDragMediator = new PointDragMediator(context, "p2", line);
                mediator.groupName = null;
                mediator.handleMouseDown(e);
                return;
            }
            
            new MarqueeSelectionMediator(context, _worldView).handleMouseDown(e);
        }
        
    }
}
