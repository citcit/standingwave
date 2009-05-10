package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.MoccasinController;
    import com.joeberkovitz.moccasin.document.ISelection;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.document.ObjectSelection;
    import com.joeberkovitz.moccasin.event.ModelUpdateEvent;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.simpleworld.model.Line;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.World;
    import com.joeberkovitz.simpleworld.model.WorldShape;
    
    import flash.events.Event;
    import flash.geom.Point;

    /**
     * Application specific subclass of MoccasinController.  This class is responsible
     * for applying modifications to the application model on behalf of the presentation layer. 
     */
    public class AppController extends MoccasinController
    {
        public function AppController(document:MoccasinDocument)
        {
            super(document);
        }
        
        /**
         * The World that is the root value object of our document model.
         */
        public function get world():World
        {
            return document.root.value as World;
        }
        
        /**
         * Add a new square to the world. 
         */
        public function addObject():Square
        {
            var square:Square = new Square();
            square.x = square.y = 100;
            square.size = 25;
            square.color = 0;
            world.shapes.addItem(square);
            document.selection = new ObjectSelection(root, [MoccasinModel.forValue(square)]);
            return square;
        }
        
        /**
         * Add a new line to the world. 
         */
        public function addLine():Line
        {
            var line:Line = new Line();
            line.x = line.y = 0;
            line.width = line.height = 100;
            world.shapes.addItem(line);
            document.selection = new ObjectSelection(root, [MoccasinModel.forValue(line)]);
            return line;
        }
        
        public function changeColor():void
        {
            var sel:ISelection = document.selection;
            for each (var m:MoccasinModel in sel.selectedModels)
            {
                WorldShape(m.value).color = 0xff0000;
            }
        }

/*        
        public function createConnections():void
        {
            if (!document.selection)
            {
                return;
            }
            var selectedModels:Array = document.selection.selectedModels.slice();
            var lines:Array = [];
            for (var i:int = 0; i < selectedModels.length; i++)
            {
                var square:Square = selectedModels[i].value as Square;
                if (square)
                {
                    for (var j:int = i+1; j < selectedModels.length; j++)
                    {
                        var square2:Square = selectedModels[j].value as Square;
                        if (square2)
                        {
                            var line:Line = new Line();
                            line.p1 = new Point(square.x, square.y);
                            line.p2 = new Point(square2.x, square2.y);
                            world.shapes.addItem(line);
                            lines.push(MoccasinModel.forValue(line));
                        }
                    }
                }
            }
            
            document.selection = new ObjectSelection(root, lines);
        }
*/

        public function rotateSquare(angle:Number):void
        {
            var sel:ISelection = document.selection;
            for each (var m:MoccasinModel in sel.selectedModels)
            {
                Square(m.value).angle += angle;
            }
        }

        /**
         * Transform pasted model objects appropriately, in this case offsetting them so that they
         * appear distinctly from the originals (if present).
         */
        override protected function transformPastedModel(model:MoccasinModel):MoccasinModel
        {
            if (model.value is WorldShape)
            {
                WorldShape(model.value).x += 10;
                WorldShape(model.value).y += 10;
            }
            return model;
        }
        
    }
}
