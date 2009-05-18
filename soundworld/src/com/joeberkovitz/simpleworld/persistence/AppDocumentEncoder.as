package com.joeberkovitz.simpleworld.persistence
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.persistence.IDocumentEncoder;
    import com.joeberkovitz.simpleworld.model.Composition;
    import com.joeberkovitz.simpleworld.model.SonicElement;
    import com.joeberkovitz.simpleworld.model.SoundClip;
    import com.joeberkovitz.simpleworld.model.Tone;

    /**
     * Application specific document encoder converting a top-level model into XML.
     */
    public class AppDocumentEncoder implements IDocumentEncoder
    {
        public function AppDocumentEncoder()
        {
        }

        public function encodeDocument(root:ModelRoot):*
        {
            var world:Composition = root.value as Composition;
            var xml:XML = <world/>;
            
            for each (var element:SonicElement in world.elements)
            {
                if (element is Tone)
                {
                    var tone:Tone = element as Tone;
                    xml.appendChild(<tone x={tone.x} y={tone.y} width={tone.width} height={tone.height}/>);
                }
                else if (element is SoundClip)
                {
                    var clip:SoundClip = element as SoundClip;
                    xml.appendChild(<soundClip x={clip.x} y={clip.y} url={clip.url} height={clip.height}/>);
                }
            }
            
            return xml;
        }
     }
}