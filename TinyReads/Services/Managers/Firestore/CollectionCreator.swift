//
//  CollectionCreator.swift
//  TinyReads
//
//  Created by user on 16.06.2026.
//

import Foundation
import Combine

@Observable
class CollectionCreator{
  
  private let model = "gemini-2.5-pro"
  
  func fetchCards() async throws -> [CollectionCreationCard]{
	 var request = try createRequest()
	 
	 request.httpMethod = "POST"
	 request.addValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let prompt = prompt(category: .nature, language: .english, count: 1)
	 let payload = generatePayload(prompt: prompt)
	 request.httpBody = try JSONSerialization.data(withJSONObject: payload)
	 
	 return try await apiRequest(request: request)
  }
  
  func apiRequest(request: URLRequest) async throws -> [CollectionCreationCard]{
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 guard let httpResponse = response as? HTTPURLResponse else {
		  throw CollectionCreatorError.missingHTTPResponse
	 }

	 guard (200..<300).contains(httpResponse.statusCode) else {
		  throw CollectionCreatorError.badStatusCode(
			 code: httpResponse.statusCode,
			 message: data.apiErrorMessage
		  )
	 }
	 
	 return try data.decodeResponse()
  }
  
  private func generatePayload(prompt: String) -> [String: Any] {
	 [
		"contents": [[
		  "parts": [["text": prompt]]
		]],
		"generationConfig": [
		  "responseMimeType": "application/json",
		  "responseSchema": outputSchema,
		  "thinkingConfig": [
			 "thinkingBudget": 4096
		  ]
		]
	 ]
  }
  
  private var outputSchema: [String: Any] {
	 [
		"type": "object",
		"properties": [
		  "reads": [
			 "type": "array",
			 "items": [
				"type": "object",
				"properties": [
				  "title": ["type": "string"],
				  "hook": ["type": "string"],
				  "body": ["type": "string"],
				  "tags": [
					 "type": "array",
					 "items": ["type": "string"]
				  ]
				],
				"required": ["title", "hook", "body", "tags"]
			 ]
		  ]
		],
		"required": ["reads"]
	 ]
  }
  
  func createRequest() throws -> URLRequest{
	 let url = try getUrl()
	 
	 let request = URLRequest(url: url)
	 
	 return request
  }
  
  func getUrl() throws -> URL{
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent") else {
		throw URLError(.badURL)
	 }
	 return url
  }
  
}

// MARK: - Content Prompts
extension CollectionCreator {
  enum PromptLanguage: String {
	 case english = "en"
	 case ukrainian = "uk"
	 
	 var instruction: String {
		switch self {
		case .english:
		  "Write in English."
		case .ukrainian:
		  "Write in Ukrainian."
		}
	 }
  }
  
  enum PromptCategory: String, CaseIterable, Identifiable {
	 case science
	 case history
	 case culture
	 case psychology
	 case philosophy
	 case technology
	 case health
	 case nature
	 case finance
	 case space
	 
	 var id: String { rawValue }
	 
	 var profile: String {
		switch self {
		case .science:
		  """
		  Explain scientific ideas, discoveries, experiments, everyday physics, biology, chemistry, and how scientific thinking works. Make the reader feel that ordinary reality is deeper and stranger than it first appears.
		  """
		case .history:
		  """
		  Explain historical events, forgotten moments, inventions, social changes, and decisions that shaped everyday life. Avoid national propaganda or culture-specific assumptions. Focus on human patterns and lessons.
		  """
		case .culture:
		  """
		  Explain art, symbols, rituals, media, language, myths, design, food, music, and everyday cultural habits. Keep it globally accessible and avoid requiring knowledge of one specific country or nationality.
		  """
		case .psychology:
		  """
		  Explain cognitive biases, behavior patterns, habits, emotion, decision-making, relationships, attention, memory, resilience, and famous psychology experiments. Keep it empathetic, practical, and scientifically grounded.
		  """
		case .philosophy:
		  """
		  Explain philosophical questions, thought experiments, ethics, meaning, identity, freedom, knowledge, logic, ancient schools, and modern ideas. Make abstract ideas feel useful in ordinary life.
		  """
		case .technology:
		  """
		  Explain artificial intelligence, computing, algorithms, networks, digital life, inventions, cybersecurity basics, robotics, and the hidden systems behind modern tools. Avoid hype and explain concepts clearly.
		  """
		case .health:
		  """
		  Explain sleep, stress, movement, nutrition basics, habits, body systems, aging, prevention, and well-being as educational knowledge only. Do not give medical advice, diagnosis, treatment instructions, or claims that replace a professional.
		  """
		case .nature:
		  """
		  Explain animals, plants, ecosystems, climate, geology, oceans, weather, evolution, and natural patterns. Keep the tone curious, grounded, and accessible without political framing.
		  """
		case .finance:
		  """
		  Explain financial systems, behavioral economics, inflation, debt, saving, risk, markets, banks, credit, and money psychology as educational knowledge only. Do not give investment advice or tell the reader what to buy, sell, or do with their money.
		  """
		case .space:
		  """
		  Explain planets, stars, black holes, time, gravity, space missions, cosmic scale, telescopes, and the search for life. Make huge cosmic ideas understandable and emotionally memorable.
		  """
		}
	 }
  }
  
  static let basePrompt = """
  You are an expert educational writer and storyteller for the Tiny Reads app.

  Tiny Reads creates short, thoughtful reading cards for curious adults. Each card should explain one idea clearly, with depth, warmth, and narrative flow.

  The reader is intelligent but not necessarily an expert. Make complex ideas accessible, useful, and memorable.

  Content Rules:
  - Title: an intriguing question or clear curiosity-driven statement.
  - Hook: 1-2 sentences that create immediate curiosity.
  - Body: 300-600 words. Use natural paragraphs. Explain one core idea deeply through examples, stories, analogies, or real-world situations.
  - Tone: calm, intelligent, conversational, not childish, not academic-heavy.
  - Avoid generic motivational writing.
  - Avoid controversial political framing.
  - Avoid medical, legal, or financial advice.
  """
  
  static let bodyFormatRules = """
  CRITICAL BODY FORMAT RULES:
  The "body" field must be plain raw text only.

  Allowed:
  - Normal letters, spaces, commas, periods, question marks, apostrophes, semicolons, colons, parentheses.
  - Paragraph breaks using exactly double newline characters: \\n\\n.

  Forbidden:
  - Markdown of any kind.
  - Headings.
  - Bullet points.
  - Numbered lists.
  - Inline code.
  - Blockquotes.
  - Asterisks.
  - Hashtags.
  - Paragraphs starting with digits or list markers.
  - Raw unescaped double quotes inside strings.

  Paragraph rules:
  - Write in natural narrative paragraphs.
  - Every paragraph must start with a normal word, not a number or symbol.
  - Do not include section labels such as "Example:", "Conclusion:", or "Key idea:".
  - Do not use bullet-like structures disguised as sentences.

  JSON safety:
  - Return valid JSON only.
  - Escape all newline characters as \\n\\n inside the JSON string.
  - Escape any double quote if it is absolutely necessary, but prefer avoiding double quotes in body text.
  - If a sentence would require quotation marks, rewrite it without quotation marks.
  """
  
  static let outputContract = """
  Return only valid JSON matching this exact shape:

  {
    "reads": [
      {
        "title": "string",
        "hook": "string",
        "body": "string",
        "tags": ["string"]
      }
    ]
  }

  Do not include id, translationGroupId, categoryId, languageCode, wordCount, estimatedMinutes, sortIndex, or isActive. These technical fields will be created by the app.
  Do not include explanations outside JSON.
  """
  
  static let silentSelfCheck = """
  Before returning JSON, silently verify:
  1. The body has no Markdown.
  2. The body has no bullet points or numbered lists.
  3. The body has no raw unescaped double quotes.
  4. Paragraphs are separated only by \\n\\n.
  5. The output is valid JSON and nothing else.
  """
  
  func prompt(
	 category: PromptCategory,
	 language: PromptLanguage,
	 count: Int
  ) -> String {
	 """
	 \(Self.basePrompt)

	 \(language.instruction)

	 Category: \(category.rawValue)
	 Category profile:
	 \(category.profile)

	 Generate \(count) Tiny Reads cards for this category.

	 \(Self.bodyFormatRules)

	 \(Self.outputContract)

	 \(Self.silentSelfCheck)
	 """
  }
}

struct CollectionCreationRoot: Decodable {
  let reads: [CollectionCreationCard]
}

struct CollectionCreationCard: Decodable{
  let title: String
  let hook: String
  let body: String
  let tags: [String]
}



struct GeminiResponse: Codable {
	 let candidates: [Candidate]
}

struct Candidate: Codable {
	 let content: ContentGeminiResponse
}

struct ContentGeminiResponse: Codable {
	 let parts: [Part]
}

struct Part: Codable {
	 let text: String
}

enum CollectionCreatorError: LocalizedError {
  case missingHTTPResponse
  case badStatusCode(code: Int, message: String)
  
  var errorDescription: String? {
	 switch self {
	 case .missingHTTPResponse:
		"Missing HTTP response."
	 case let .badStatusCode(code, message):
		"Gemini request failed with status \(code): \(message)"
	 }
  }
}



extension Data{
  func getContentFromResponse() throws -> String{
	 let decoded = try JSONDecoder().decode(GeminiResponse.self, from: self)
	 if let generatedText = decoded.candidates.first?.content.parts.first?.text{
		return generatedText
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
	 
	 
  }
  
  func decodeResponse() throws -> [CollectionCreationCard]{
	 let content = try self.getContentFromResponse()
	 let json = content.extractedJSONObject()
	 
	 if let data = json.data(using: .utf8){
		let root = try JSONDecoder().decode(CollectionCreationRoot.self, from: data)
		return root.reads
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
  }
}

private extension Data {
  var apiErrorMessage: String {
	 if
		let object = try? JSONSerialization.jsonObject(with: self) as? [String: Any],
		let error = object["error"] as? [String: Any] {
		let status = error["status"] as? String
		let message = error["message"] as? String
		return [status, message]
		  .compactMap { $0 }
		  .joined(separator: ": ")
	 }
	 
	 if let body = String(data: self, encoding: .utf8), !body.isEmpty {
		return body
	 }
	 
	 return "No response body."
  }
}

extension String {
  func extractedJSONObject() -> String {
	 let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
	 
	 guard
		let start = trimmed.firstIndex(of: "{"),
		let end = trimmed.lastIndex(of: "}"),
		start <= end
	 else {
		return trimmed
	 }
	 
	 return String(trimmed[start...end])
  }
}
