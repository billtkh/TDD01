//
//  ListingGroupViewController.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ListingGroupViewController: ViewController {
    let viewModel: ListingGroupViewModel
    
    let disposeBag = DisposeBag()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ListingCell.self, forCellReuseIdentifier: NSStringFromClass(ListingCell.self))
        return tableView
    }()
    
    private(set) lazy var groupSelectionView: ListingGroupSelectionView = {
        let groupSelectionView = ListingGroupSelectionView(viewModel: viewModel.groupSelection)
        return groupSelectionView
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = .gray
        view.alpha = 0.8
        view.clipsToBounds = true
        view.snp.makeConstraints({ (make) in
            make.width.height.equalTo(80)
        })
        
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.startAnimating()
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    private lazy var nextButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
        barButtonItem.setCommonStyle()
        return barButtonItem
    }()
    
    private lazy var clearButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: nil, action: nil)
        barButtonItem.setCommonStyle()
        return barButtonItem
    }()
    
    private lazy var connectionButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Connect", style: .plain, target: nil, action: nil)
        barButtonItem.setCommonStyle()
        return barButtonItem
    }()
    
    init(viewModel: ListingGroupViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        binding()
    }
    
    override func setupUI() {
        super.setupUI()
        
        navigationItem.leftBarButtonItems = [nextButtonItem, clearButtonItem]
        navigationItem.rightBarButtonItem = connectionButtonItem
        navigationItem.titleView = groupSelectionView
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints({ (make) in
            make.center.equalTo(view.center)
        })
    }
    
    func binding() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .listing(let listings):
                self.loadingView.isHidden = true
                self.tableView.delegate = nil
                self.tableView.dataSource = nil
                Observable.of(listings)
                    .asDriver(onErrorJustReturn: [])
                    .drive(self.tableView.rx.items) { (tableView, row, element) in
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListingCell.self)) as? ListingCell else { return UITableViewCell() }
                        cell.updateUI(viewModel: element)
                        return cell
                    }.disposed(by: self.disposeBag)
                
            case .loading(_):
                self.loadingView.isHidden = false
                
            case .disconnected:
                self.loadingView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        nextButtonItem.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.groupSelection.next()
        }).disposed(by: disposeBag)
        
        clearButtonItem.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.clear()
        }).disposed(by: disposeBag)
        
        connectionButtonItem.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let buttonItem = self?.connectionButtonItem, let viewModel = self?.viewModel else { return }
            if viewModel.connectRelay.value {
                viewModel.disconnect()
                buttonItem.title = "Connect"
            } else {
                viewModel.connect(groupType: viewModel.groupSelection.selectedType.value)
                buttonItem.title = "Disconnect"
            }
        }).disposed(by: disposeBag)
    }
}

extension UIBarButtonItem {
    func setCommonStyle() {
        setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ], for: .normal)
        setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ], for: .highlighted)
    }
}
