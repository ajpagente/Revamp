/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

class RVCMSDecoder {

    var decoder: CMSDecoder
    private var isFinalized = false

    init?() {
        var decoderRef: CMSDecoder?
        let osStatus = CMSDecoderCreate(&decoderRef)
        // TODO: Check return value

        guard let unwrappedDecoder = decoderRef else {
            return nil
        }

        self.decoder = unwrappedDecoder
    }

    func updateMessage(with message: NSData) -> Bool {
        let osStatus = CMSDecoderUpdateMessage(decoder, message.bytes, message.length)
        // TODO: Check return value s

        if osStatus == errSecSuccess { 
            isFinalized = false
            return true 
        }

        return false
    }

    func finalizeMessage() -> Bool {
        let osStatus = CMSDecoderFinalizeMessage(decoder)
        // TODO: Check return value

        if osStatus == errSecSuccess { 
            isFinalized = true
            return true 
        }

        return false
    }

    var data: Data? {
        var content: CFData?
        
        if !isFinalized { return nil }

        let osStatus = CMSDecoderCopyContent(decoder, &content)
        // TODO: Check return value

        return content as Data?
    }
}
