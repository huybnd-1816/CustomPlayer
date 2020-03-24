//
//  ViewController.swift
//  CustomPlayer
//
//  Created by mac on 6/10/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import AVFoundation

final class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    fileprivate var viewModel: MainViewModel!
    fileprivate let audioManager = AudioManager.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Deselect selected tableview cell
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func config() {
        navigationItem.title = "Music Player"
        tableView.tableFooterView = UIView(frame: .zero)
        viewModel = MainViewModel()
        viewModel.reloadData()
        viewModel.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                print(error!.localizedDescription)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel != nil {
            return viewModel.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = viewModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        audioManager.playAudio(viewModel[indexPath.row])
        TimeCountDown.shared.pauseTimer()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.songIndex = indexPath.row
        vc.bindingData(viewModel.songs)
        present(vc, animated: true, completion: nil)
    }
}
