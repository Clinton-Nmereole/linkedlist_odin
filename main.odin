package main

import "core:fmt"

list_errors :: enum {
	TryingOperationOnEmptyList,
}

linked_list_error :: struct {
	error_message: string,
	error_type:    list_errors,
}


Node :: struct {
	value: any,
	next:  ^Node,
}

LinkedList :: struct {
	head:   ^Node,
	length: uint,
}


append_item :: proc(list: ^LinkedList, node: ^Node) {
	if list.head != nil {
		curr := list.head
		for curr.next != nil {
			curr = curr.next
		}
		curr.next = node
		list.length += 1
	} else {
		list.head = node
		list.length += 1
	}

}

pop :: proc(list: ^LinkedList) -> (node: ^Node, error: linked_list_error) {
	if list.head == nil && list.length == 0 {
		return nil, linked_list_error {
			error_message = "You are trying to pop an item from a list that is empty",
			error_type = .TryingOperationOnEmptyList,
		}
	} else if list.head != nil && list.length == 1 {
		curr := list.head
		list.head = nil
		list.length -= 1
		return &curr^, linked_list_error{}
	} else {
		curr, prev := list.head.next, list.head
		for curr.next != nil {
			curr = curr.next
			prev = prev.next
		}
		prev.next = nil
		list.length -= 1

		return &curr^, linked_list_error{}

	}

}

printlist :: proc(list: ^LinkedList) -> list_errors {

	if list.head == nil {
		return list_errors.TryingOperationOnEmptyList
	} else {
		curr := list.head
		for curr != nil {
			fmt.print(curr.value, "->")
			curr = curr.next
		}
	}
	fmt.println()
	return nil
}

main :: proc() {


	my_node := Node {
		value = 5,
		next  = nil,
	}

	my_node_two := Node {
		value = 10,
		next  = nil,
	}

	my_linkedlist := LinkedList{}

	append_item(&my_linkedlist, &my_node)
	append_item(&my_linkedlist, &my_node_two)

	printlist(&my_linkedlist)

	popped_item, err := pop(&my_linkedlist)
	pop(&my_linkedlist)
	fmt.println(pop(&my_linkedlist))

	printlist(&my_linkedlist)
	fmt.println(popped_item.value)

}
