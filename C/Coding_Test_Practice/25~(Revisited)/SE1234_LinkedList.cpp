#include <iostream>
using namespace std;

class node {
public:
    int num;
    node* next;
    node* prev;

    node(int _num, node* _prev, node* _next) {
        num = _num;
        prev = _prev;
        next = _next;
    }

    void insert_after(node* _prev) {
        node* tmp = _prev->next;
        _prev->next = this;
        this->prev = _prev;
        this->next = tmp;
        if (tmp) tmp->prev = this;
    }

    void remove_from_list() {
        if (prev) prev->next = next;
        if (next) next->prev = prev;
    }
};

int main() {
    ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);

    for(int c = 0; c<10; c++){
        int n;
        cin >> n;

        node start(-1, nullptr, nullptr);
        node end(-1, &start, nullptr);
        start.next = &end;

        node* last = &start;
        for (int i = 0; i < n; i++) {
            char a;
            cin >> a;
            node* newnode = new node(a-'0', nullptr, nullptr);
            newnode->insert_after(last);
            last = newnode;
        }

        // 반복적으로 인접한 동일 숫자 노드 제거
        node* it = start.next;
        while (it != &end && it->next != &end) {
            if (it->num == it->next->num) {
                node* del1 = it;
                node* del2 = it->next;
                node* next_it = del2->next;

                del1->remove_from_list();
                del2->remove_from_list();

                delete del1;
                delete del2;

                it = start.next; // 처음부터 다시 검사
            }
            else {
                it = it->next;
            }
        }

        cout << '#' << c+1 << " ";
        // 결과 출력
        for (node* cur = start.next; cur != &end; cur = cur->next) {
            cout << cur->num;
        }
        cout << '\n';

        // 메모리 정리
        it = start.next;
        while (it != &end) {
            node* next = it->next;
            delete it;
            it = next;
        }
    }
    return 0;
}
