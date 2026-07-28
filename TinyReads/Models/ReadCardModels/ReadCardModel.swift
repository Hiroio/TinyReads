//
//  ReadCardModel.swift
//  TinyReads
//
//  Created by user on 28.05.2026.
//

import Foundation
import SwiftUI

nonisolated struct ReadCardModel: Identifiable, Codable {
	 let id: String
	 let translationGroupId: String
	 let categoryId: String
	 let languageCode: String
	 let title: String
	 let hook: String
	 let body: String
	 let wordCount: Int
	 let estimatedMinutes: Int
	 let tags: [String]
	 let sortIndex: Int
	 var isActive: Bool
}


nonisolated struct RootReads: Codable { let reads: [ReadCardModel] }


extension ReadCardModel: Equatable {
  static func == (lhs: ReadCardModel, rhs: ReadCardModel) -> Bool {
	 lhs.id == rhs.id
  }
  
  static func getForPreview(language: String = "en") -> ReadCardModel{
	 if language == "uk" {
		ReadCardModel(
		  id: "1",
		  translationGroupId: "",
		  categoryId: "philosophy",
		  languageCode: "uk",
		  title: "Чому ми продовжуємо дивитися поганий фільм до кінця?",
		  hook: "Ви заплатили за квиток і вже через 20 хвилин розумієте, що фільм жахливий. Але ви залишаєтеся, бо “вже ж заплатили”. Це омана незворотних витрат, і вона змушує нас приймати погані рішення щодня.",
		  body: "Омана незворотних витрат (Sunk Cost Fallacy) — це поширена когнітивна помилка, яка полягає в тому, що ми продовжуємо інвестувати час, гроші або зусилля в щось, що виявилося невдалим, лише тому, що ми вже багато в це вклали. Ми приймаємо рішення на основі минулих, вже втрачених ресурсів, а не на основі майбутніх перспектив.\n\nНезворотні витрати (sunk costs) — це ті витрати, які вже були зроблені і які неможливо повернути. Раціональна економічна теорія говорить, що при прийнятті майбутніх рішень ми повинні ігнорувати незворотні витрати. Гроші за квиток у кіно вже втрачені, незалежно від того, чи залишитеся ви на сеансі. Час, витрачений на невдалий бізнес-проєкт, вже не повернути.\n\nЧому ж ми так вперто чіпляємося за ці втрати? Психологи пояснюють це кількома причинами. По-перше, ми не любимо визнавати свої помилки. Продовжуючи інвестувати, ми ніби відкладаємо момент, коли доведеться сказати собі: “Я зробив поганий вибір”. По-друге, ми схильні до “уникнення втрат” (loss aversion) — біль від втрати відчувається нами сильніше, ніж радість від еквівалентного здобутку. Відмова від проєкту означає зафіксувати втрату, що є психологічно болючим. По-третє, ми сподіваємося на диво і думаємо, що ще трохи зусиль — і все налагодиться.\n\nЦя омана проявляється в багатьох сферах життя:\n\n   Бізнес: Компанія продовжує фінансувати збитковий проєкт, бо “ми вже вклали в нього мільйони”.\n   Стосунки: Люди залишаються в нещасливих стосунках, бо “ми вже стільки років разом”.\n   Повсякденне життя: Ви доїдаєте величезну порцію несмачної їжі в ресторані, бо “за неї заплачено”. Або продовжуєте читати нудну книгу до кінця, бо “вже прочитали половину”.\n\nЯк подолати цю оману? Ключ — це змістити фокус з минулого на майбутнє. У кожний момент прийняття рішення ставте собі питання: “Якби я не мав цієї історії і цих вкладень, чи зробив би я такий вибір прямо зараз?”. Якщо ви вже заплатили за фільм, запитайте себе: “Що є кращим використанням моїх наступних двох годин: дивитися цей жахливий фільм чи піти додому і почитати книгу?”. Вміння “списати втрати” і рухатися далі є ознакою раціонального мислення і ключем до більш ефективних рішень.",
		  wordCount: 427,
		  estimatedMinutes: 3,
		  tags: ["логічні хиби", "когнітивні упередження", "психологія", "критичне мислення"],
		  sortIndex: 1,
		  isActive: true
		)
	 }else{
		ReadCardModel(
		  id: "psychology_en_001",
		  translationGroupId: "psychology_en_001",
		  categoryId: "psychology",
		  languageCode: "en",
		  title: "Why Do We Only See What We Believe?",
		  hook: "Have you ever noticed that once you believe something, you start seeing evidence for it everywhere? This isn't a coincidence; it's your brain playing a clever trick on you.",
		  body: "This phenomenon is called Confirmation Bias, one of the most pervasive cognitive biases. It's our brain's tendency to search for, interpret, favor, and recall information in a way that confirms or supports our preexisting beliefs or hypotheses. Think of it as wearing a special pair of glasses that only highlights things that agree with you, while making contradictory evidence blurry or invisible.\nImagine you've just bought a new red car. Suddenly, you start seeing red cars everywhere you go. Are there suddenly more red cars on the road? Not at all. Your brain, now primed to recognize this specific car, is actively filtering your perception to notice what it deems important. The same process happens with our beliefs. If you believe that a particular political party is incompetent, you'll be hyper-aware of every news story, comment, or statistic that proves your point. Meanwhile, any information suggesting their competence will be easily dismissed, ignored, or explained away as an exception to the rule.\nThis bias isn't born from a desire to be wrong; it's a mental shortcut. Our brains are bombarded with an overwhelming amount of information every second. Sifting through it all impartially would be exhausting. So, to save energy, our brain prioritizes information that fits into our existing mental frameworks. It’s simply easier to process information that aligns with what we already know than it is to rewire our entire belief system in response to new, conflicting data.\nIn the digital age, confirmation bias is supercharged. Social media feeds, search engines, and news aggregators use algorithms designed to show us what we want to see. They learn our preferences and feed us a steady diet of content that validates our existing opinions, creating a 'filter bubble' or 'echo chamber'. This makes us feel more certain in our beliefs, but it also isolates us from different perspectives, making it harder to have productive conversations and find common ground. Understanding confirmation bias is the first step to overcoming it. By consciously seeking out opposing viewpoints and questioning our own assumptions, we can begin to see the world not just as we believe it to be, but as it truly is.",
		  wordCount: 458,
		  estimatedMinutes: 3,
		  tags: [],
		  sortIndex: 1,
		  isActive: true
		)
	 }
	 
  }
}





// MARK: Category Enum
enum ReadCategories: String, CaseIterable, Identifiable{
  case science, history, culture, psychology, philosophy, nature, finance, health, space, technology
  
  var id: String { self.rawValue}
  
  var title: LocalizedStringKey {
	 switch self {
	 case .science:
		"Science"
	 case .history:
		"History"
	 case .culture:
		"Culture"
	 case .psychology:
		"Psychology"
	 case .philosophy:
		"Philosophy"
	 case .nature:
		"Nature"
	 case .finance:
		"Finance"
	 case .health:
		"Health"
	 case .space:
		"Space"
	 case .technology:
		"Technology"
	 }
  }
  
  var limit: Int{
	 switch self {
	 default:
		100
	 }
  }

  /// StoreKit product ID of this category's extra-cards pack, if one exists yet.
  var extraPackStoreID: String? {
	 switch self {
	 case .science: StoreCategoriesConfigurationEnum.sciencePack.storeID
	 case .history: StoreCategoriesConfigurationEnum.historyPack.storeID
	 case .psychology: StoreCategoriesConfigurationEnum.psychologyPack.storeID
	 case .philosophy: StoreCategoriesConfigurationEnum.philosophyPack.storeID
	 case .finance: StoreCategoriesConfigurationEnum.financePack.storeID
	 case .culture, .nature, .health, .space, .technology: nil
	 }
  }

  /// Base limit, extended by 100 if the user owns this category's pack.
  func effectiveLimit(purchasedIDs: Set<String>) -> Int {
	 guard let packID = extraPackStoreID, purchasedIDs.contains(packID) else { return limit }
	 return limit + 100
  }

  func userDefaultKey(language: LanguageEnum) -> String {
	 "\(language.code)_\(self.rawValue)_key"
  }
}
