package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.Line;
    
    import flash.display.DisplayObject;

    /**
     * View of a Line. 
     */
    public class LineView extends ShapeView
    {
        public function LineView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }
        
        /**
         * The Line object associated with this view's MoccasinModel.
         */
        public function get line():Line
        {
            return model.value as Line;
        }
        
        /**
         * Update this view by drawing the appropriate graphics.
         */
        override protected function updateView():void
        {
            super.updateView();

            graphics.lineStyle(3, line.color);
            graphics.moveTo(0, 0);
            graphics.lineTo(line.width, line.height);
        }
        
        /**
         * Create a feedback view that will be superimposed on this view in a transparent layer.
         */        
        override protected function createFeedbackView():DisplayObject
        {
            return new LineFeedback(context, model);
        }
    }
}
