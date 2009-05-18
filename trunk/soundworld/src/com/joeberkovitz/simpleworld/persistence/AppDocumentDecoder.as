package com.joeberkovitz.simpleworld.persistence
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.persistence.IDocumentDecoder;
    import com.joeberkovitz.simpleworld.model.Composition;
    import com.joeberkovitz.simpleworld.model.SoundClip;
    import com.joeberkovitz.simpleworld.model.Tone;

    /**
     * Application specific XML decoder that creates a top-level model object from an XML document.
     */
    public class AppDocumentDecoder implements IDocumentDecoder
    {
        public function AppDocumentDecoder()
        {
        }

        public function decodeDocument(data:*):ModelRoot
        {
            var xml:XML = data as XML;
            var world:Composition = new Composition();
            
            for each (var shapeXml:XML in xml.children())
            {
                switch (shapeXml.name().toString())
                {
                    case "tone":
                        var tone:Tone = new Tone();
                        tone.x = shapeXml.@x;
                        tone.y = shapeXml.@y;
                        tone.width = shapeXml.@width;
                        tone.height = shapeXml.@height;
                        world.elements.addItem(tone);
                        break;

                    case "soundClip":
                        var clip:SoundClip = new SoundClip();
                        clip.x = shapeXml.@x;
                        clip.y = shapeXml.@y;
                        clip.url = shapeXml.@url;
                        clip.height = shapeXml.@height;
                        world.elements.addItem(clip);
                        break;
                }
            }
            
            return new ModelRoot(world);
        }
    }
}