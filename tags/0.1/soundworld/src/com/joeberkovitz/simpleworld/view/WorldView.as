package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.IMoccasinView;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.WorldMediator;
    import com.joeberkovitz.simpleworld.model.Line;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.World;
    
    import flash.utils.getQualifiedClassName;

    /**
     * View of the entire sample application's World value object.
     */
    public class WorldView extends MoccasinView
    {
        public function WorldView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }
        
        /**
         * The World of which this is a view.
         */
        public function get world():World
        {
            return model.value as World;
        }
        
        /**
         * Initialize this object by creating the appropriate mediator to handle events.
         */
        override protected function initialize():void
        {
            super.initialize();
            new WorldMediator(context).handleViewEvents(this);
        }
        
        /**
         * Update the view by drawing the backdrop for the world.
         */
        override protected function updateView():void
        {
            super.updateView();
            
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(0, 0, world.width, world.height);
            graphics.endFill();
        }

        /**
         * Create a child view for some child model of our model. 
         * @param child a child MoccasinModel
         * @return the appropriate type of view for the value object belonging to that child.
         */
        override public function createChildView(child:MoccasinModel):IMoccasinView
        {
            if (child.value is Square)
            {
                return new SquareView(context, child);
            }
            else if (child.value is Line)
            {
                return new LineView(context, child);
            }
            else
            {
                throw new Error("Unrecognized model type: " + getQualifiedClassName(child));
            }
        }
    }
}