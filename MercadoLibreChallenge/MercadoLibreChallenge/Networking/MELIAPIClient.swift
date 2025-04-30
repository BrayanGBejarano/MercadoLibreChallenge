//
//  MELIAPIClient.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation

protocol MELIAPIClientProtocol {
    func searchItems(query: String, completion: @escaping (Result<[Item], APIError>) -> Void)
    func getItemDetails(id: String, completion: @escaping (Result<ItemDetail, APIError>) -> Void)
}

final class MELIAPIClient: MELIAPIClientProtocol {
    
    // MARK: - Properties
    private let baseURL = "https://api.mercadolibre.com"
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    private let accessToken = "APP_USR-8228172616681660-042619-390a7a4cef6387e85aca1d4d8c191aaf-2411555080"
    
    // MARK: - Initialization
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession 
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public Methods
    func searchItems(query: String, completion: @escaping (Result<[Item], APIError>) -> Void) {
        let endpoint = Endpoint.search(query: query)
        request(endpoint: endpoint, completion: completion)
    }
    
    func getItemDetails(id: String, completion: @escaping (Result<ItemDetail, APIError>) -> Void) {
        let endpoint = Endpoint.itemDetails(id: id)
        request(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - Private Methods
    private func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = endpoint.buildURL(baseURL: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Debug: Verificar request antes de enviar
        print("\n📡 Request a la API:")
        print("URL: \(url.absoluteString)")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Debug: Verificar respuesta
            if let error = error {
                print("🔴 Error en la request: \(error.localizedDescription)")
                completion(.failure(.requestFailed(description: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("🔴 Respuesta inválida")
                completion(.failure(.invalidResponse))
                return
            }
            
            print("🟠 Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = self.handleErrorResponse(data: data, statusCode: httpResponse.statusCode)
                print("🔴 Error en la respuesta: \(error.localizedDescription)")
                if let data = data {
                    print("🔴 Cuerpo del error: \(String(data: data, encoding: .utf8) ?? "")")
                }
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("🔴 No se recibieron datos")
                completion(.failure(.noData))
                return
            }
            
            // Debug: Verificar datos recibidos
            print("🟢 Datos recibidos (\(data.count) bytes):")
            print(String(data: data, encoding: .utf8)?.prefix(500) ?? "No se puede mostrar")
            
            do {
                let decodedObject = try self.jsonDecoder.decode(T.self, from: data)
                print("🟢 Decodificación exitosa")
                completion(.success(decodedObject))
            } catch {
                print("🔴 Error decodificando: \(error)")
                completion(.failure(.decodingFailed(description: error.localizedDescription)))
            }
        }
        
        task.resume()
    }
    
    private func handleErrorResponse(data: Data?, statusCode: Int) -> APIError {
        guard let data = data else {
            return .serverError(code: statusCode, message: "No se recibieron datos del error")
        }
        
        do {
            let errorResponse = try jsonDecoder.decode(ErrorResponse.self, from: data)
            return .serverError(code: statusCode, message: errorResponse.message)
        } catch {
            return .serverError(code: statusCode, message: String(data: data, encoding: .utf8))
        }
    }
}
