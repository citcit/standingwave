package com.joeberkovitz.simpleworld.service
{
    import com.joeberkovitz.moccasin.service.AbstractOperation;
    import com.joeberkovitz.moccasin.service.HttpDocumentService;
    import com.joeberkovitz.moccasin.service.IOperation;
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    import com.joeberkovitz.simpleworld.persistence.AppDocumentDecoder;
    import com.joeberkovitz.simpleworld.persistence.AppDocumentEncoder;
    
    import mx.controls.Alert;
    
    /**
     * Application specific document service responsible for document persistence. 
     * This overrides the abstract AIR file-based persistence service by providing
     * an XML decoder and encoder.
     */
    public class AppDocumentService extends HttpDocumentService
    {
        public function AppDocumentService()
        {
            super(new AppDocumentDecoder(), new AppDocumentEncoder());
        }
        
        override public function saveDocument(documentData:MoccasinDocumentData):IOperation
        {
            Alert.show("Save only supported in Simpleworld AIR Demo");
            return new AbstractOperation(); 
        }
    }
}
