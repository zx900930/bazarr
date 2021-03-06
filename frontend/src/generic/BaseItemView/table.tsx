import { uniqBy } from "lodash";
import React, { useCallback, useMemo } from "react";
import { TableOptions, TableUpdater, useRowSelect } from "react-table";
import { SharedProps } from ".";
import { useLanguageProfiles } from "../../@redux/hooks";
import {
  AsyncPageTable,
  ItemEditorModal,
  SimpleTable,
  useShowModal,
} from "../../components";
import { TableStyleProps } from "../../components/tables/BaseTable";
import { useCustomSelection } from "../../components/tables/plugins";
import { buildOrderList, GetItemId } from "../../utilites";

interface Props<T extends Item.Base> extends SharedProps<T> {
  dirtyItems: readonly T[];
  editMode: boolean;
  select: React.Dispatch<T[]>;
}

function Table<T extends Item.Base>({
  state,
  dirtyItems,
  modify,
  editMode,
  select,
  columns,
  loader,
  name,
}: Props<T>) {
  const showModal = useShowModal();

  const updateRow = useCallback<TableUpdater<T>>(
    (row, modalKey: string) => {
      showModal(modalKey, row.original);
    },
    [showModal]
  );

  const idState = state.data;

  const orderList = useMemo(() => buildOrderList(idState), [idState]);

  const data = useMemo(() => uniqBy([...dirtyItems, ...orderList], GetItemId), [
    dirtyItems,
    orderList,
  ]);

  const [profiles] = useLanguageProfiles();

  const options: Partial<TableOptions<T> & TableStyleProps<T>> = {
    loose: [profiles],
    emptyText: `No ${name} Found`,
    externalUpdate: updateRow,
  };

  return (
    <React.Fragment>
      {editMode ? (
        // TODO: Use PageTable
        <SimpleTable
          {...options}
          columns={columns}
          data={data}
          onSelect={select}
          isSelecting={true}
          plugins={[useRowSelect, useCustomSelection]}
        ></SimpleTable>
      ) : (
        <AsyncPageTable
          {...options}
          columns={columns}
          aos={state}
          loader={loader}
          data={[]}
        ></AsyncPageTable>
      )}
      <ItemEditorModal modalKey="edit" submit={modify}></ItemEditorModal>
    </React.Fragment>
  );
}

export default Table;
