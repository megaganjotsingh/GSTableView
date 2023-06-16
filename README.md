# GSTableView

Easy to Use
  ---
  
  ### You can simply define datasource and delegate methods with simple

  ```swift
         GSTableViewSectionDataSource<AnyHashable, AnyHashable>(
            dataSource: {
                return (
                    'Model for Section',
                    'Model for Rows'
                )
            },
            dequeReusableCell: { table, model in
                return UITableViewCell() // simply dequeue reusable cell here and return that cell
            }, didSelectCell: { model in
                print(model)
            }
        )
  ```

  ### You can pass the above datasource as below and according to array's elements cells are organised
  
    ```swift
        tableView.datasource = {
            return ['give your datasources here']
        }
        tableView.setDataSource()
        tableView.applyChanges()
    ```
  
  Collaboration
---

I tried to build an easy to use API, but I'm sure there are ways of improving and adding more features, If you think that we can do the GSTableView more powerful please contribute with this project.
