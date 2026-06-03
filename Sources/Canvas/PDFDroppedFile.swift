//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 03/06/2026.
//--------------------------------------------------------------------------------------------------

import CoreTransferable
import UniformTypeIdentifiers

//--------------------------------------------------------------------------------------------------

public struct PDFDroppedFile : Transferable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let url : URL

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Il faut faire immédiatement une copie du fichier, sinon on ne peut pas le lire
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var transferRepresentation: some TransferRepresentation {
    FileRepresentation (importedContentType: .pdf) { received in
      let sourceURL = received.file
      let destinationURL = FileManager.default.temporaryDirectory
        .appendingPathComponent (UUID().uuidString + ".pdf")
      try FileManager.default.copyItem (at: sourceURL, to: destinationURL)
      return PDFDroppedFile (url: destinationURL)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
