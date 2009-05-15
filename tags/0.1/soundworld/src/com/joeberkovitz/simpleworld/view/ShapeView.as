package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.SelectableView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.ShapeDragMediator;
    import com.joeberkovitz.simpleworld.model.WorldShape;

    /**
     * View of a WorldShape value object in this application.  ShapeViews may be dragged around if
     * appropriate, and they move to track the object's position when that changes. 
     */
    public class ShapeView extends SelectableView
    {
        private var _allowDrag:Boolean;
        
        /**
         * Create a view of a WorldShape. 
         * 
         * @param context the ViewContext shared by all views in this document view
         * @param model a MoccasinModel whose value object is the shape to be displayed
         * @param allowDrag an optional flag controlling the draggability of this view.
         * 
         */
        public function ShapeView(context:ViewContext, model:MoccasinModel, allowDrag:Boolean = true)
        {
            super(context, model);
            _allowDrag = allowDrag;
        }
        
        /**
         * The shape that this view presents.
         */
        public function get shape():WorldShape
        {
            return model.value as WorldShape;
        }
        
        /**
         * Initialize this view by adding a mediator for drag handling, if specified.
         */
        override protected function initialize():void
        {
            super.initialize();
            if (_allowDrag)
            {
                new ShapeDragMediator(context).handleViewEvents(this);
            }
        }
        
        /**
         * Update this view by adjusting its position.
         */
        override protected function updateView():void
        {
            super.updateView();
            
            x = shape.x;
            y = shape.y;
        }
    }
}