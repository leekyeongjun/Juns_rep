using UnityEngine;
using UnityEngine.EventSystems;

public class DraggableUIElement : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    private RectTransform rectTransform;
    private RectTransform parent_rectTransform;
    private Vector2 offset;
    private Camera cam;


    private void Start()
    {
        rectTransform = GetComponent<RectTransform>();
        parent_rectTransform = transform.parent.GetComponent<RectTransform>();
        cam = UIManager.ui.cam;
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        transform.parent.SetAsLastSibling();
        eventData.pointerDrag.GetComponent<CanvasGroup>().blocksRaycasts = false;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(parent_rectTransform, eventData.position, cam, out Vector2 beginpos);
        offset = beginpos; 
    }

    public void OnDrag(PointerEventData eventData)
    {

        RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransform, eventData.position, cam, out Vector2 pos);
        rectTransform.parent.position=rectTransform.TransformPoint(new Vector2(pos.x-offset.x, pos.y-offset.y));
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        // 드래그 종료 시, 더 이상 클릭 이벤트를 차단하지 않음
        eventData.pointerDrag.GetComponent<CanvasGroup>().blocksRaycasts = true;
    }

    

}