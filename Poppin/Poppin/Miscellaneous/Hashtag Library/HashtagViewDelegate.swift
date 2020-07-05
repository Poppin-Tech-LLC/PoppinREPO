//
//  HashtagViewDelegate.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/9/18.
//
import UIKit

public protocol HashtagViewDelegate: class {
    func hashtagRemoved(hashtag: HashTag)
    func viewShouldResizeTo(size: CGSize)
}
