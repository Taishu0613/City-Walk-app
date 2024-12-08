//
//  sampleLive_ActivityLiveActivity.swift
//  sampleLive Activity
//
//  Created by 若杉泰周 on 2024/12/08.
//

import ActivityKit
import WidgetKit
import SwiftUI

// Activityの属性を定義する構造体
struct sampleLive_ActivityAttributes: ActivityAttributes {
    // 動的に変化するプロパティを格納する内部構造体
    public struct ContentState: Codable, Hashable {
        // Activityの動的な状態を表すプロパティ
        var emoji: String // ユーザーが設定できる絵文字
        var prefecture: String // 現在地の住所の県
        var city: String //　現在地の住所の市
    }

    // 固定のプロパティを定義（変化しないデータ）
    var name: String // Activityの名前
}

// Widgetを定義する構造体
struct sampleLive_ActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        // ActivityConfigurationを使用してActivityの設定を定義
        ActivityConfiguration(for: sampleLive_ActivityAttributes.self) { context in
            // ロックスクリーンやバナーのUIを定義
            HStack {
                VStack {
                    Text(" \(context.state.prefecture)")
                    Text(" \(context.state.city)")
                }
                Spacer()
                VStack {
                    Text("こんにちはあああああaaaあああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああaaaaああaa \(context.state.emoji)") // 動的状態の絵文字を表示
                        .lineLimit(nil)
                }
            }
            .frame(minHeight: 170)
            .padding()
            .activityBackgroundTint(Color.cyan) // 背景の色を設定
            .activitySystemActionForegroundColor(Color.black) // ボタンやテキストの色を設定

        } dynamicIsland: { context in
            // Dynamic Island（ダイナミックアイランド）のUIを定義
            DynamicIsland {
                // 展開時のUIを構築（リージョンごとに定義）
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading") // 左側の領域
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing") // 右側の領域
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)") // 下部領域
                }
            } compactLeading: {
                Text("L") // コンパクト表示時の左側
            } compactTrailing: {
                Text("T \(context.state.emoji)") // コンパクト表示時の右側
            } minimal: {
                Text(context.state.emoji) // 最小限表示
            }
            .widgetURL(URL(string: "http://www.apple.com")) // ウィジェットをタップしたときのURL
            .keylineTint(Color.red) // キーラインの色
        }
    }
}

// プレビュー用のサンプルデータを拡張として定義
extension sampleLive_ActivityAttributes {
    // プレビューに使用する固定のサンプルデータ
    fileprivate static var preview: sampleLive_ActivityAttributes {
        sampleLive_ActivityAttributes(name: "World")
    }
}

// プレビュー用の動的状態のサンプルデータ
extension sampleLive_ActivityAttributes.ContentState {
    // 笑顔の絵文字を設定したサンプルデータ
    fileprivate static var smiley: sampleLive_ActivityAttributes.ContentState {
        sampleLive_ActivityAttributes.ContentState(emoji: "😀",prefecture: "東京",city: "新宿")
     }
     
     // 星目の絵文字を設定したサンプルデータ
     fileprivate static var starEyes: sampleLive_ActivityAttributes.ContentState {
         sampleLive_ActivityAttributes.ContentState(emoji: "🤩",prefecture: "愛知",city: "西尾")
     }
}

// プレビューを設定
#Preview("Notification", as: .content, using: sampleLive_ActivityAttributes.preview) {
   sampleLive_ActivityLiveActivity() // プレビュー用のWidgetを設定
} contentStates: {
    // 複数の状態をプレビューに設定
    sampleLive_ActivityAttributes.ContentState.smiley
    sampleLive_ActivityAttributes.ContentState.starEyes
}
