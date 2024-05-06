package hsd

import (
	"log"
	"os"
	"reflect"
	"testing"
)

func TestMain(m *testing.M) {
	log.Println("Before")
	ret := m.Run()
	log.Println("After")
	os.Exit(ret)
}

func TestStringDistance(t *testing.T) {
	tests := []struct {
		name string
		lhs  string
		rhs  string
		want int
	}{
		{name: "lhs is longer than rhs", lhs: "foo", rhs: "fo", want: -1},
		{name: "rhs is shorter than rhs", lhs: "fo", rhs: "foo", want: -1},
		{name: "No diff", lhs: "foo", rhs: "foo", want: 0},
		{name: "1 diff", lhs: "foo", rhs: "foh", want: 1},
		{name: "2 diffs", lhs: "foo", rhs: "fhh", want: 2},
		{name: "3 diffs", lhs: "foo", rhs: "hhh", want: 3},
		{name: "multibute", lhs: "あいう", rhs: "あいえ", want: 1},
	}

	for _, tc := range tests {
		got := StringDistance(tc.lhs, tc.rhs)
		if !reflect.DeepEqual(tc.want, got) {
			t.Fatalf("%s: expected: %v, got: %v", tc.name, tc.want, got)
		}
	}
}
