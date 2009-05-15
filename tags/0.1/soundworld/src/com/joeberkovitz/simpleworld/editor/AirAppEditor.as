package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.editor.AirMoccasinEditor;
    import com.joeberkovitz.moccasin.editor.EditorKeyMediator;
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.service.IMoccasinDocumentService;
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    import com.joeberkovitz.moccasin.view.IMoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.AppController;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.World;
    import com.joeberkovitz.simpleworld.model.WorldShape;
    import com.joeberkovitz.simpleworld.service.AirAppDocumentService;
    import com.joeberkovitz.simpleworld.view.WorldView;
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.filters.EnvelopeFilter;
    import com.noteflight.standingwave2.output.AudioPlayer;
    import com.noteflight.standingwave2.performance.AudioPerformer;
    import com.noteflight.standingwave2.performance.ListPerformance;
    import com.noteflight.standingwave2.sources.SineSource;
    import com.noteflight.standingwave2.utils.AudioUtils;
    
    import flash.display.Sprite;
    
    import mx.binding.utils.BindingUtils;
    

    /**
     * AIR version of the AppEditor/
     */
    public class AirAppEditor extends AirMoccasinEditor
    {
        private var _player:AudioPlayer;
        private var _playbackCursor:Sprite;

        private const PIX_PER_SECOND:Number = 500;
        private const PIX_PER_OCTAVE:Number = 100;
        private const PIX_PER_DB:Number = 10;
                
        
        override public function initializeEditor():void
        {
            super.initializeEditor();
            loadFromDocumentData(new MoccasinDocumentData(new ModelRoot(new World()), null));
            _player = new AudioPlayer();
            
            _playbackCursor = new Sprite();
            _playbackCursor.graphics.lineStyle(1, 0);
            _playbackCursor.graphics.moveTo(0, 0);
            _playbackCursor.graphics.lineTo(0, 1000);
            feedbackLayer.addChild(_playbackCursor);
            
            BindingUtils.bindProperty(this, "playbackPosition", _player, "position");
        }
        
        public function set playbackPosition(value:Number):void
        {
            _playbackCursor.x = value * PIX_PER_SECOND;
        }
        
        /**
         * Override base class to create application-specific controller. 
         */
        override protected function createController():IMoccasinController
        {
            return new AppController(null);
        }
        
        /**
         * Override base class to create application-specific keystroke mediator. 
         */
        override protected function createKeyMediator(controller:IMoccasinController):EditorKeyMediator
        {
            return new AppKeyMediator(controller, this);
        }
        
        /**
         * Override base class to create application-specific top-level view of model. 
         */
        override protected function createDocumentView(context:ViewContext):IMoccasinView
        {
            return new WorldView(context, controller.document.root);
        } 

        /**
         * Override base class to instantiate application-specific service to load and save documents. 
         */
        override protected function createDocumentService():IMoccasinDocumentService
        {
            return new AirAppDocumentService();
        }
        
        public function startPlayback():void
        {
            var p:ListPerformance = new ListPerformance();
            for each (var shape:WorldShape in World(moccasinDocument.root.value).shapes)
            {
                var square:Square = shape as Square;
                if (!square)
                {
                    continue;
                }
                
                var duration:Number = square.size / PIX_PER_SECOND;
                var startTime:Number = square.x / PIX_PER_SECOND;
                var amplitude:Number = AudioUtils.decibelsToFactor(-20 + square.size / PIX_PER_DB);
                var frequency:Number = 440 * Math.exp((400 - square.y) * Math.LN2 / PIX_PER_OCTAVE);
                var source:IAudioSource = new SineSource(new AudioDescriptor(), duration + 0.1, frequency, amplitude);
                source = new EnvelopeFilter(source, 0.01, 0, 1, duration - 0.01, 0.1);
                p.addSourceAt(startTime, source);
            }
            
            _player.play(new AudioPerformer(p));
        }
        
        public function stopPlayback():void
        {
            _player.stop();
        }
    }
}