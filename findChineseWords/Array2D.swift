//
//  Array2D.swift
//  chineseWordPuzzle
//
//  Created by Alvis Poon on 12/7/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

struct Array2D<T> {
  let columns: Int
  let rows: Int
  private var array: Array<T?>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(repeating: nil, count: rows*columns)
  }
  
  subscript(column: Int, row: Int) -> T? {
    get {
      return array[row*columns + column]
    }
    set {
      array[row*columns + column] = newValue
    }
  }
}
