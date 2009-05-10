package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.SelectionHandle;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.PointDragMediator;
    import com.joeberkovitz.simpleworld.model.Line;

    public class LineFeedback extends ShapeView
    {
        private var _p1Handle:SelectionHandle;
        private var _p2Handle:SelectionHandle;
        
        public function LineFeedback(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model, false);
            initialize();
            
            new PointDragMediator(context, "p1").handleViewEvents(this, _p1Handle);
            new PointDragMediator(context, "p2").handleViewEvents(this, _p2Handle);
        }
        
        public function get line():Line
        {
            return model.value as Line;
        }
        
        override protected function createChildren():void
        {
            super.createChildren();

            _p1Handle = new SelectionHandle(context);
            addChild(_p1Handle);
            
            _p2Handle = new SelectionHandle(context);
            addChild(_p2Handle);
        }

        override protected function updateView():void
        {
            super.updateView();

            _p1Handle.x = 0;
            _p1Handle.y = 0;
            _p2Handle.x = line.width;
            _p2Handle.y = line.height;
        }
    }
}