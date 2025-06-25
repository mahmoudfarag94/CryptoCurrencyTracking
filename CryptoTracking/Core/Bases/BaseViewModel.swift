//
//  BaseViewModel.swift
//  CryptoTracking
//
//  Created bym Mahmoud Farag on 25/12/2024.
//
import Combine
import Foundation

protocol BaseViewModel: ObservableObject {
    associatedtype Model: Equatable
    var state: ViewState<Model> { get set }
    func fetchData()
  
}

extension BaseViewModel {
    func handleSuccess(_ result: Model) {
        DispatchQueue.main.async {
            self.state = .success(result)
        }
    }
    
    func handleError(_ error: AppError) {
        DispatchQueue.main.async {
            self.state = .error(error.errorDescription)
        }
    }
}


class BaseCryptoViewModel: BaseViewModel {
  
    typealias Model = [Cryptocurrency]
    var data: [Cryptocurrency] = [] {
        didSet {
            handleSuccess(data)
        }
    }
    
    @Published var state: ViewState<Model> = .idle
    private(set) var fetchUseCase: FetchPricesUseCase
    
    init(fetchUseCase: FetchPricesUseCase = FetchPricesUseCaseImpl()) {
        self.fetchUseCase = fetchUseCase
        fetchData()
        observe()
    }
    
    func observe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: .CryptoChange,
            object: nil
        )
    }
    
    func onChange(symbol: String, isFavorite: Bool) {
        self.data = self.data.map { item in
            var updatedItem = item
            if item.symbol == symbol {
                updatedItem.isFavorite = isFavorite
            }
            return updatedItem
        }
    }
    
    func fetchData() {
        state = .loading
        Task { @MainActor in
            do {
                let cryptos = try await fetchUseCase.execute()
                self.data = cryptos
                
            } catch let err as AppError {
                handleError(err)
            }
        }
    }
    
    func handleSuccess(_ cryptos: Model) {
        DispatchQueue.main.async {
            self.state = .success(cryptos)
        }
    }
    
    func handleError(_ error: AppError) {
        DispatchQueue.main.async {
            self.state = .error(error.errorDescription)
        }
    }
    
    @objc private func handleNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
               let symbol = userInfo["symbol"] as? String,
               let isFavorite = userInfo["isFavorite"] as? Bool else {
             return
         }
         
         let tuple: (String, Bool) = (symbol, isFavorite)
        onChange(symbol: tuple.0, isFavorite: tuple.1)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .CryptoChange, object: nil)
    }

}
