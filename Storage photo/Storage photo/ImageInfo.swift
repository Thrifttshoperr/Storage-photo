import Foundation
import UIKit

class ImageInfo: Codable {
    
    var name: String
    var comment: String
    var like: Bool
   
    init(name: String, comment: String, like: Bool) {
        
        self.name = name
        self.comment = comment
        self.like = like
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case comment
        case like
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(comment, forKey: .comment)
        try container.encode(like, forKey: .like)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.like = try container.decode(Bool.self, forKey: .like)
    }
    
}

