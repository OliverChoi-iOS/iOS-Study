//
//  PhotoImage.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import SwiftUI

struct PhotoImage: Transferable {
    let data: Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(
            importedContentType: .image,
            importing: { data in
                guard let uiImage = UIImage(data: data) else {
                    throw PhotoPickerError.importFailed
                }
                
                guard let data = uiImage.jpegData(compressionQuality: 0.3) else {
                    throw PhotoPickerError.importFailed
                }
                
                return PhotoImage(data: data)
            }
        )
    }
}
