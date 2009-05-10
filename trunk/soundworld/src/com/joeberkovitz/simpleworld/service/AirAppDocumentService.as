package com.joeberkovitz.simpleworld.service
{
    import com.joeberkovitz.moccasin.service.FileDocumentService;
    import com.joeberkovitz.simpleworld.persistence.AppDocumentDecoder;
    import com.joeberkovitz.simpleworld.persistence.AppDocumentEncoder;
    
    /**
     * Application specific document service responsible for document persistence. 
     * This overrides the abstract AIR file-based persistence service by providing
     * an XML decoder and encoder.
     */
    public class AirAppDocumentService extends FileDocumentService
    {
        public function AirAppDocumentService()
        {
            super(new AppDocumentDecoder(), new AppDocumentEncoder());
        }
    }
}