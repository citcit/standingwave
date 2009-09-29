package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.SoundClip;
    import com.joeberkovitz.simpleworld.view.CompositionView;
    
    import flash.desktop.ClipboardFormats;
    import flash.desktop.NativeDragManager;
    import flash.events.MouseEvent;
    import flash.events.NativeDragEvent;

    /**
     * Mediator for the CompositionView.
     */
    public class CompositionMediator extends DragMediator
    {
        private var _worldView:CompositionView;
        
        public function CompositionMediator(context:ViewContext)
        {
            super(context);
        }
        
        /**
         * Handle events on behalf of a CompositionView.
         */
        public function handleViewEvents(view:CompositionView):void
        {
            _worldView = view;
            view.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
            view.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, handleNativeDragEnter);
            view.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, handleNativeDragDrop);
        }
        
        public function handleNativeDragEnter(e:NativeDragEvent):void
        {
            NativeDragManager.acceptDragDrop(_worldView);
        }
        
        public function handleNativeDragDrop(e:NativeDragEvent):void
        {
            var clip:SoundClip = new SoundClip();
            clip.url = e.clipboard.getData(ClipboardFormats.URL_FORMAT) as String;
            clip.height = 20;
            clip.x = e.localX;
            clip.y = e.localY;
            
            _worldView.context.controller.document.undoHistory.openGroup("Add Sound Clip");
            _worldView.world.elements.addItem(clip);
        }
        
        override public function handleMouseDown(e:MouseEvent):void
        {
            new MarqueeSelectionMediator(context, _worldView).handleMouseDown(e);
        }
        
    }
}
