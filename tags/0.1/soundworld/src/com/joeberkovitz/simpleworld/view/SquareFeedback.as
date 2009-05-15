package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.SelectionHandle;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.PointDragMediator;
    import com.joeberkovitz.simpleworld.model.Square;
    
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Feedback variation of a SquareView that displays associated resizing handle in the editor's
     * feedbackLayer UIComponent. Note that this extends ShapeView and thus inherits its position-tracking behavior.
     */
    public class SquareFeedback extends ShapeView
    {
        private var _sizeHandle:SelectionHandle;
        private var _outline:Sprite;
        
        public function SquareFeedback(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model, false);
            initialize();
            
            new PointDragMediator(context, "corner").handleViewEvents(this, _sizeHandle);
        }
        
        public function get square():Square
        {
            return model.value as Square;
        }
        
        override protected function createChildren():void
        {
            super.createChildren();

            // create the resize handle
            _sizeHandle = new SelectionHandle(context);
            addChild(_sizeHandle);
            
            _outline = new Sprite();
            addChild(_outline);
        }

        override protected function updateView():void
        {
            super.updateView();
                        
            // Draw a gray selection border around the square
            _outline.graphics.clear();
            _outline.rotation = square.angle * 180 / Math.PI;
            _outline.graphics.lineStyle(1, 0x999999);
            _outline.graphics.drawRect(-square.size/2, -square.size/2, square.size, square.size);

            // reposition the resizing handle
            _sizeHandle.x = square.cornerX - square.x;
            _sizeHandle.y = square.cornerY - square.y;
        }
    }
}