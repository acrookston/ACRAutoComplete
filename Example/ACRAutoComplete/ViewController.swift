//
//  ViewController.swift
//  ACRAutoComplete
//
//  Created by Andrew Crookston on 09/20/2016.
//  Copyright (c) 2016 Andrew Crookston. All rights reserved.
//

import UIKit
import ACRAutoComplete

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var words = [Word]()
    var autoComplete = AutoComplete<Word>()
    var results = [Word]()
    var searching = false

    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.showsCancelButton = true
        return searchBar
    }()


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
        tableView.tableHeaderView = searchBar

//        autoComplete.insert(Word(word: "abc"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        words = []
        autoComplete = AutoComplete<Word>()
        loadWords()
    }

    func loadWords() {
        guard words.count == 0 else { return }

        guard let path = Bundle.main.path(forResource: "sowpods", ofType: "txt") else { return }

        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)

                printTimeElapsedWhenRunningCode(title: "parsing words", operation: {
                    data.components(separatedBy: .newlines).forEach({
                        self.words.append(Word(word: $0))
                    })
                })

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                printTimeElapsedWhenRunningCode(title: "indexing words", operation: {
                    for word in self.words {
                        self.autoComplete.insert(word)
                    }
                })
            } catch {
                print(error)
            }
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        searching = text != ""
        if searching {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                printTimeElapsedWhenRunningCode(title: "searching \(text)", operation: {
                    self.results = self.autoComplete.search(text) // .sorted(by: { $0.word < $1.word })
                })

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searching = false
        results = []
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return results.count
        }
        return words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.identifier) as! LabelCell
        if searching {
            cell.label.text = results[indexPath.row].word
        } else {
            cell.label.text = words[indexPath.row].word
        }
        return cell
    }

    // MARK: - UITableViewDelegate


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            UIPasteboard.general.string = results[indexPath.row].word
        } else {
            UIPasteboard.general.string = words[indexPath.row].word
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) s")
}
